class Api::CreditResource < JSONAPI::Resource
  after_save :notify_status_changed
  attributes :status,
             :loan,
             :dispersion_receipt,
             :contract,
             :contract_url,
             :contract_filename,
             :contract_size,
             :contract_content_type,
             :contract_uploaded_at,
             :authorization,
             :authorization_url,
             :authorization_filename,
             :authorization_size,
             :authorization_content_type,
             :authorization_uploaded_at,
             :payroll_receipt,
             :payroll_receipt_url,
             :payroll_receipt_filename,
             :payroll_receipt_size,
             :payroll_receipt_content_type,
             :payroll_receipt_uploaded_at,
             :reason,
             :contract_status,
             :contract_rejection_reason,
             :authorization_status,
             :authorization_rejection_reason,
             :payroll_receipt_status,
             :payroll_receipt_rejection_reason,
             :dispersed_at,
             :installation_status,
             :installation_date,
             :created_at,
             :updated_at
  has_one :borrower, foreign_key: "user_id", class_name: "User"
  has_one :term_offering
  has_many :payments

  filters :status, :installation_status

  def fetchable_fields
    super - %i[contract authorization payroll_receipt dispersion_receipt]
  end

  filter :company,
         apply: ->(records, value, _options) do
           return records if value[0] == nil
           records.where(
             term_offering_id:
               TermOffering.where(company_id: value[0]).pluck(:id)
           )
         end

  private

  def notify_status_changed
    if @model.saved_change_to_status?
      if @model.status == "pending"
        PendingCreditNotifier.with(record: @model).deliver(
          User.with_any_role(:admin, :authorizations)
        )
      end
      if @model.status == "invalid-documentation"
        InvalidDocumentationCreditNotifier.with(
          record: @model,
          handler_name: handler_name
        ).deliver(User.with_any_role(:admin, :authorizations))
      end
      if @model.status == "authorized"
        AuthorizedCreditNotifier.with(
          record: @model,
          handler_name: handler_name
        ).deliver(User.with_any_role(:admin, :dispersions, :authorizations))
      end
      if @model.status == "denied"
        DeniedCreditNotifier.with(
          record: @model,
          handler_name: handler_name
        ).deliver(User.with_any_role(:admin, :authorizations))
      end
      if @model.status == "dispersed"
        DispersedCreditNotifier.with(
          record: @model,
          handler_name: handler_name
        ).deliver(User.with_any_role(:admin, :dispersions))
      end
    end
  end

  def handler_name
    nil if context.nil? || context[:current_user].nil?
    "#{context[:current_user].first_name} #{context[:current_user].last_name}"
  end
end
