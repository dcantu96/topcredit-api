class Credit < ApplicationRecord
  belongs_to :borrower,
             foreign_key: "user_id",
             class_name: "User",
             optional: false
  belongs_to :term_offering, optional: false
  has_many :payments, dependent: :destroy
  has_one_attached :contract
  has_one_attached :authorization
  has_one_attached :payroll_receipt
  has_one_attached :dispersion_receipt

  before_save :add_amortization_and_credit_amount
  after_save :add_payments, if: :saved_change_to_dispersed_at?

  validates_inclusion_of :status,
                         in: %w[
                           new
                           pending
                           invalid-documentation
                           authorized
                           denied
                           dispersed
                           settled
                           defaulted
                         ]
  validates_inclusion_of :contract_status,
                         in: %w[pending approved rejected],
                         allow_nil: true
  validates_inclusion_of :authorization_status,
                         in: %w[pending approved rejected],
                         allow_nil: true
  validates_inclusion_of :payroll_receipt_status,
                         in: %w[pending approved rejected],
                         allow_nil: true
  validates_inclusion_of :hr_status, in: %w[approved denied], allow_nil: true
  validate :borrower_email_matches_term_offering_company_domain
  validate :dispersed_credits_must_have_dispersion_receipt
  validate :dispersed_credits_must_have_dispersed_at
  validate :dispersed_and_authorized_credit_must_have_approved_documents
  validate :dispersed_credits_must_be_active
  validate :borrower_must_be_pre_authorized
  validate :validate_loan_change, if: :will_save_change_to_loan?
  validate :first_discount_date_can_only_be_mid_month_or_end_of_month
  validate :hr_approval_needs_first_discount_date
  validate :can_only_have_one_dispersed_credit_per_borrower
  validate :validate_term_offering_change,
           if: :will_save_change_to_term_offering_id?

  scope :dispersed, -> { where(status: "dispersed") }

  def fully_paid?
    (payments.sum(:amount) + 0.01.to_d) >= credit_amount.to_d
  end

  def contract_url
    contract.blob.url if contract.attached?
  end

  def contract_filename
    contract.blob.filename.to_s if contract.attached?
  end

  def contract_size
    contract.blob.byte_size if contract.attached?
  end

  def contract_content_type
    contract.blob.content_type if contract.attached?
  end

  def contract_uploaded_at
    contract.blob.created_at if contract.attached?
  end

  def authorization_url
    authorization.blob.url if authorization.attached?
  end

  def authorization_filename
    authorization.blob.filename.to_s if authorization.attached?
  end

  def authorization_size
    authorization.blob.byte_size if authorization.attached?
  end

  def authorization_content_type
    authorization.blob.content_type if authorization.attached?
  end

  def authorization_uploaded_at
    authorization.blob.created_at if authorization.attached?
  end

  def payroll_receipt_url
    payroll_receipt.blob.url if payroll_receipt.attached?
  end

  def payroll_receipt_filename
    payroll_receipt.blob.filename.to_s if payroll_receipt.attached?
  end

  def payroll_receipt_size
    payroll_receipt.blob.byte_size if payroll_receipt.attached?
  end

  def payroll_receipt_content_type
    payroll_receipt.blob.content_type if payroll_receipt.attached?
  end

  def payroll_receipt_uploaded_at
    payroll_receipt.blob.created_at if payroll_receipt.attached?
  end

  def dispersed?
    status == "dispersed"
  end

  private

  def hr_approved?
    hr_status == "approved"
  end

  def first_discount_date_can_only_be_mid_month_or_end_of_month
    return unless first_discount_date

    if first_discount_date.day != 15 &&
         first_discount_date.day != first_discount_date.end_of_month.day
      errors.add(:first_discount_date, :invalid)
    end
  end

  def borrower_email_matches_term_offering_company_domain
    return unless borrower && term_offering && term_offering.company

    borrower_domain = borrower.email.split("@").last
    unless term_offering.company.domain.include?(borrower_domain)
      errors.add(
        :borrower,
        "email domain must match the term offering's company domain"
      )
    end
  end

  def invalid_documentation_status
    if status == "invalid-documentation" &&
         (
           contract_status != "rejected" &&
             authorization_status != "rejected" &&
             payroll_receipt_status != "rejected"
         )
      errors.add(:status, :invalid_status_change)
    end
  end

  def dispersed_credits_must_have_dispersion_receipt
    if status == "dispersed" && !dispersion_receipt.attached?
      errors.add(:dispersion_receipt, :blank)
    end
  end

  def dispersed_credits_must_be_active
    if status == "dispersed" && hr_status != "approved"
      errors.add(:hr_status, :must_be_approved)
    end
  end

  def dispersed_credits_must_have_dispersed_at
    if status == "dispersed" && dispersed_at.nil?
      errors.add(:dispersed_at, :blank)
    end
  end

  def dispersed_and_authorized_credit_must_have_approved_documents
    if (
         (status == "dispersed" || status == "authorized") &&
           (
             contract_status != "approved" ||
               authorization_status != "approved" ||
               payroll_receipt_status != "approved"
           )
       )
      errors.add(:status, :invalid_status_change)
    end
  end

  def borrower_must_be_pre_authorized
    if borrower.status != "pre-authorized"
      errors.add(:borrower, :must_be_pre_authorized)
    end
  end

  def validate_loan_change
    if (status == "dispersed" || status == "authorized") && persisted?
      errors.add(:loan, :cannot_change_after_authorized)
    end
  end

  def validate_term_offering_change
    if (status == "dispersed" || status == "authorized") && persisted?
      errors.add(:term_offering, :cannot_change_after_authorized)
    end
  end

  def add_amortization_and_credit_amount
    if will_save_change_to_term_offering_id? || will_save_change_to_loan?
      self.amortization =
        Payments.emi(
          loan,
          term_offering.company.rate_with_tax,
          term_offering.term.duration,
          term_offering.term.duration_type
        )
      self.credit_amount =
        Payments.credit_amount(
          loan,
          term_offering.company.rate_with_tax,
          term_offering.term.duration,
          term_offering.term.duration_type
        )
      self.max_loan_amount =
        Payments.max_loan_amount(
          borrower.salary,
          term_offering.company.borrowing_capacity,
          term_offering.company.rate_with_tax,
          term_offering.term.duration,
          term_offering.term.duration_type
        )
    end
  end

  def add_payments
    return if payments.count > 0

    term_duration = term_offering.term.duration
    term_duration_type = term_offering.term.duration_type
    payment_count = 1
    expected_payment_date = first_discount_date

    while payment_count <= term_duration
      payments.create!(
        expected_at: expected_payment_date,
        expected_amount: amortization,
        number: payment_count
      )
      payment_count += 1
      expected_payment_date =
        Payments.get_next_payment_date(
          expected_payment_date,
          term_duration_type
        )
    end
  end

  def hr_approval_needs_first_discount_date
    if hr_status == "approved" && first_discount_date.nil?
      errors.add(:first_discount_date, :blank)
    end
  end

  def can_only_have_one_dispersed_credit_per_borrower
    return unless borrower

    if borrower.credits.dispersed.count > 1
      errors.add(:borrower, :has_dispersed_credit)
    end
  end
end
