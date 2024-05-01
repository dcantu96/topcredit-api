class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable

  has_many :access_grants,
           class_name: "Doorkeeper::AccessGrant",
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: "Doorkeeper::AccessToken",
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :credits, dependent: :destroy
  has_many :notifications,
           as: :recipient,
           dependent: :destroy,
           class_name: "Noticed::Notification"
  has_many :notification_mentions,
           as: :record,
           dependent: :destroy,
           class_name: "Noticed::Event"
  has_one_attached :identity_document
  has_one_attached :bank_statement
  has_one_attached :payroll_receipt
  has_one_attached :proof_of_address
  belongs_to :handled_by, class_name: "User", optional: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true
  validates_inclusion_of :status,
                         in: %w[
                           new
                           pending
                           pre-authorization
                           pre-authorized
                           invalid-documentation
                           denied
                         ]
  validates_inclusion_of :state,
                         in: %w[
                           AGU
                           BCN
                           BCS
                           CAM
                           CHP
                           CHH
                           COA
                           COL
                           DUR
                           GUA
                           GRO
                           HID
                           JAL
                           MEX
                           MIC
                           MOR
                           NAY
                           NLE
                           OAX
                           PUE
                           QUE
                           ROO
                           SLP
                           SIN
                           SON
                           TAB
                           TAM
                           TLA
                           VER
                           YUC
                           ZAC
                         ],
                         allow_nil: true
  validates_inclusion_of :identity_document_status,
                         in: %w[pending approved rejected],
                         allow_nil: true
  validates_inclusion_of :bank_statement_status,
                         in: %w[pending approved rejected],
                         allow_nil: true
  validates_inclusion_of :payroll_receipt_status,
                         in: %w[pending approved rejected],
                         allow_nil: true
  validates_inclusion_of :proof_of_address_status,
                         in: %w[pending approved rejected],
                         allow_nil: true
  validate :email_of_company_domain
  validate :invalid_documentation_status
  validate :pre_authorization_status_must_have_approved_documents

  def all_roles
    roles.pluck(:name)
  end

  def identity_document_url
    identity_document.blob.url if identity_document.attached?
  end

  def identity_document_filename
    identity_document.blob.filename.to_s if identity_document.attached?
  end

  def identity_document_size
    identity_document.blob.byte_size if identity_document.attached?
  end

  def identity_document_content_type
    identity_document.blob.content_type if identity_document.attached?
  end

  def identity_document_uploaded_at
    identity_document.blob.created_at if identity_document.attached?
  end

  def bank_statement_url
    bank_statement.blob.url if bank_statement.attached?
  end

  def bank_statement_filename
    bank_statement.blob.filename.to_s if bank_statement.attached?
  end

  def bank_statement_size
    bank_statement.blob.byte_size if bank_statement.attached?
  end

  def bank_statement_content_type
    bank_statement.blob.content_type if bank_statement.attached?
  end

  def bank_statement_uploaded_at
    bank_statement.blob.created_at if bank_statement.attached?
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

  def proof_of_address_url
    proof_of_address.blob.url if proof_of_address.attached?
  end

  def proof_of_address_filename
    proof_of_address.blob.filename.to_s if proof_of_address.attached?
  end

  def proof_of_address_size
    proof_of_address.blob.byte_size if proof_of_address.attached?
  end

  def proof_of_address_content_type
    proof_of_address.blob.content_type if proof_of_address.attached?
  end

  def proof_of_address_uploaded_at
    proof_of_address.blob.created_at if proof_of_address.attached?
  end

  private

  def email_of_company_domain
    if Company.find_by(domain: email.split("@").last).nil?
      errors.add(:email, :invalid_domain)
    end
  end

  def invalid_documentation_status
    if status == "invalid-documentation" &&
         (
           identity_document_status != "rejected" &&
             bank_statement_status != "rejected" &&
             payroll_receipt_status != "rejected" &&
             proof_of_address_status != "rejected"
         )
      errors.add(:status, :invalid_status_change)
    end
  end

  def pre_authorization_status_must_have_approved_documents
    if (
         status == "pre-authorization" &&
           (
             identity_document_status != "approved" ||
               identity_document == nil ||
               bank_statement_status != "approved" || bank_statement == nil ||
               payroll_receipt_status != "approved" || payroll_receipt == nil ||
               proof_of_address_status != "approved" || proof_of_address == nil
           )
       )
      errors.add(
        :status,
        :pre_authorization_status_must_have_approved_documents
      )
    end
  end
end
