class Api::UserResource < JSONAPI::Resource
  after_save :notify_status_changed
  attributes :first_name,
             :last_name,
             :email,
             :phone,
             :password,
             :employee_number,
             :bank_account_number,
             :address_line_one,
             :address_line_two,
             :city,
             :state,
             :postal_code,
             :country,
             :rfc,
             :salary,
             :status,
             :identity_document,
             :identity_document_url,
             :identity_document_filename,
             :identity_document_size,
             :identity_document_content_type,
             :identity_document_uploaded_at,
             :bank_statement,
             :bank_statement_url,
             :bank_statement_filename,
             :bank_statement_size,
             :bank_statement_content_type,
             :bank_statement_uploaded_at,
             :payroll_receipt,
             :payroll_receipt_url,
             :payroll_receipt_filename,
             :payroll_receipt_size,
             :payroll_receipt_content_type,
             :payroll_receipt_uploaded_at,
             :proof_of_address,
             :proof_of_address_url,
             :proof_of_address_filename,
             :proof_of_address_size,
             :proof_of_address_content_type,
             :proof_of_address_uploaded_at,
             :reason,
             :identity_document_status,
             :identity_document_rejection_reason,
             :bank_statement_status,
             :bank_statement_rejection_reason,
             :payroll_receipt_status,
             :payroll_receipt_rejection_reason,
             :proof_of_address_status,
             :proof_of_address_rejection_reason,
             :created_at,
             :updated_at

  has_many :credits
  has_one :handled_by, class_name: "User"
  has_one :hr_company, class_name: "Company", optional: true
  has_many :notifications

  filter :status
  filter :employee_number
  filter :last_name

  filter :query,
         apply: ->(records, value, _options) do
           query_strings = value.first.split(" ")

           # Initialize an array to store the individual conditions
           conditions = []
           # Initialize a hash to store the query parameters
           query_params = {}

           # Iterate over each query string and build conditions
           query_strings.each_with_index do |query_string, index|
             param_key = "query#{index}"
             conditions << "(first_name ILIKE :#{param_key} OR last_name ILIKE :#{param_key} OR email ILIKE :#{param_key} OR employee_number ILIKE :#{param_key})"
             query_params[param_key.to_sym] = "%#{query_string}%"
           end

           # Combine the conditions into a single string separated by OR
           combined_conditions = conditions.join(" OR ")

           # Combine conditions and query params
           records
             .without_role(:admin)
             .without_role(:authorizations)
             .without_role(:companies)
             .without_role(:dispersions)
             .without_role(:hr)
             .without_role(:payments)
             .without_role(:pre_authorizations)
             .without_role(:requests)
             .where(combined_conditions, query_params)
         end

  filter :by_role,
         apply: ->(records, value, _options) do
           if value[0] == nil
             return(
               records
                 .without_role(:admin)
                 .without_role(:authorizations)
                 .without_role(:companies)
                 .without_role(:dispersions)
                 .without_role(:hr)
                 .without_role(:payments)
                 .without_role(:pre_authorizations)
                 .without_role(:requests)
             )
           end
           records.with_role(value[0])
         end

  def fetchable_fields
    super -
      %i[
        password
        identity_document
        bank_statement
        payroll_receipt
        proof_of_address
      ]
  end

  private

  def notify_status_changed
    if @model.saved_change_to_status?
      if @model.status == "pending"
        PendingUserNotifier.with(record: @model).deliver(
          User.with_any_role(:admin, :requests)
        )
      end

      if @model.status == "invalid-documentation"
        InvalidDocumentationUserNotifier.with(
          record: @model,
          handler_name: handler_name
        ).deliver(User.with_any_role(:admin, :requests))
      end
      if @model.status == "pre-authorization"
        PreAuthorizationUserNotifier.with(
          record: @model,
          handler_name: handler_name
        ).deliver(User.with_any_role(:admin, :requests, :pre_authorizations))
      end
      if @model.status == "pre-authorized"
        PreAuthorizedUserNotifier.with(
          record: @model,
          handler_name: handler_name
        ).deliver(
          User.with_any_role(:admin, :pre_authorizations, :authorizations)
        )
      end
      if @model.status == "denied"
        DeniedUserNotifier.with(
          record: @model,
          handler_name: handler_name
        ).deliver(User.with_any_role(:admin, :requests, :pre_authorizations))
      end
    end
  end

  def handler_name
    nil if context.nil? || context[:current_user].nil?
    "#{context[:current_user].first_name} #{context[:current_user].last_name}"
  end
end

# - DeniedUserNotifier

# - When a user status is set to "denied"

# - Roles: :admin, :pre_authorizations, :requests

# - Content: "Solicitud del cliente #{record.first_name} denegada por #{params[:handler_name]}"

# - InvalidDocumentationUserNotifier

# - When a user status is set to "invalid-documentation"

# - Roles: :admin, :requests

# - Content: "Solicitud del cliente #{record.first_name} marcada con documentación inválida por #{params[:handler_name]}"

# - PreAuthorizedUserNotifier

# - When a user status is set to "pre-authorized"

# - Roles: :admin, :pre_authorizations

# - Content: "Solicitud del cliente #{record.first_name} pre autorizada por #{params[:handler_name]}"
