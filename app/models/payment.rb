class Payment < ApplicationRecord
  after_save :update_credit_status, if: :fully_paid?

  belongs_to :credit

  validates_presence_of :credit
  validates_presence_of :number
  validates_numericality_of :expected_amount, greater_than: 0
  validates_numericality_of :amount, greater_than: 0, allow_nil: true
  validates_numericality_of :number, greater_than: 0
  validates_uniqueness_of :number, scope: :credit_id
  validates_uniqueness_of :expected_at, scope: :credit_id

  validate :credit_must_dispersed
  validate :credit_must_be_approved_by_hr
  validate :must_be_confirmed_by_hr_to_set_amount

  scope :paid, -> { where.not(paid_at: nil) }
  scope :unpaid, -> { where(paid_at: nil) }

  private

  def update_credit_status
    credit.update status: "settled"
  end

  def fully_paid?
    credit.fully_paid?
  end

  def credit_must_dispersed
    errors.add(:credit, :must_be_dispersed) unless credit.dispersed_at.present?
  end

  def credit_must_be_approved_by_hr
    unless credit.hr_status == "approved"
      errors.add(:credit, :must_be_approved_by_hr)
    end
  end

  def must_be_confirmed_by_hr_to_set_amount
    if hr_confirmed_at.nil? && amount.present?
      errors.add(:amount, :must_be_confirmed_by_hr_to_set_amount)
    end
  end
end
