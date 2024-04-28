class Credit < ApplicationRecord
  belongs_to :borrower, foreign_key: 'user_id', class_name: 'User', optional: false
  belongs_to :term_offering, optional: false
  has_many :payments, dependent: :destroy
  has_one_attached :contract
  has_one_attached :authorization
  has_one_attached :payroll_receipt

  validates_inclusion_of :status, in: %w( new pending invalid-documentation authorized denied dispersed finished )
  validates_inclusion_of :contract_status, in: %w( pending approved rejected ), allow_nil: true
  validates_inclusion_of :authorization_status, in: %w( pending approved rejected ), allow_nil: true
  validates_inclusion_of :payroll_receipt_status, in: %w( pending approved rejected ), allow_nil: true
  validates_inclusion_of :installation_status, in: %w( installed ), allow_nil: true
  validate :dispersed_credits_must_have_dispersed_at
  validate :dispersed_and_authorized_credit_must_have_approved_documents
  validate :borrower_must_be_pre_authorized

  scope :dispersed, -> { where(status: 'dispersed') }

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

  private

  def invalid_documentation_status
    if status == 'invalid-documentation' && (contract_status != 'rejected' && authorization_status != 'rejected' && payroll_receipt_status != 'rejected')
      errors.add(:status, :invalid_status_change)
    end
  end

  def dispersed_credits_must_have_dispersed_at
    if status == 'dispersed' && dispersed_at.nil?
      errors.add(:dispersed_at, :blank)
    end
  end

  def dispersed_and_authorized_credit_must_have_approved_documents
    if ((status == 'dispersed' || status == 'authorized') && (contract_status != 'approved' || authorization_status != 'approved' || payroll_receipt_status != 'approved'))
      errors.add(:status, :invalid_status_change)
    end
  end

  def borrower_must_be_pre_authorized
    if borrower.status != 'pre-authorized'
      errors.add(:status, :borrower_must_be_pre_authorized)
    end
  end
end
