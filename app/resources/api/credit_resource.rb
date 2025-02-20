class Api::CreditResource < JSONAPI::Resource
  after_save :notify_status_changed
  attributes :amortization,
             :authorization_content_type,
             :authorization_filename,
             :authorization_rejection_reason,
             :authorization_size,
             :authorization_status,
             :authorization_uploaded_at,
             :authorization_url,
             :authorization,
             :contract_content_type,
             :contract_filename,
             :contract_rejection_reason,
             :contract_size,
             :contract_status,
             :contract_uploaded_at,
             :contract_url,
             :contract,
             :created_at,
             :credit_amount,
             :dispersed_at,
             :dispersion_receipt,
             :hr_status,
             :loan,
             :max_loan_amount,
             :first_discount_date,
             :payroll_receipt_content_type,
             :payroll_receipt_filename,
             :payroll_receipt_rejection_reason,
             :payroll_receipt_size,
             :payroll_receipt_status,
             :payroll_receipt_uploaded_at,
             :payroll_receipt_url,
             :payroll_receipt,
             :reason,
             :status,
             :updated_at
  has_one :borrower, foreign_key: "user_id", class_name: "User"
  has_one :term_offering
  has_many :payments

  filters :status

  def fetchable_fields
    super - %i[contract authorization payroll_receipt dispersion_receipt]
  end

  filter :hr_status,
         apply: ->(records, value, _options) do
           return records if value[0] == nil
           if value[0] == "null"
             return records.where(hr_status: nil)
           else
             records.where(hr_status: value[0])
           end
         end

  filter :company,
         apply: ->(records, value, _options) do
           return records if value[0] == nil

           records
             .includes(term_offering: :company)
             .references(:companies)
             .where(companies: { id: value[0] })
         end

  filter :dispersed_at_range,
         apply: ->(records, value, _options) do
           Time.zone = "Monterrey"
           first_half = Time.current.day <= 15
           case value.first
           when "last-7-days"
             return(
               records.joins(:credits).where(
                 credits: {
                   dispersed_at: 7.days.ago.beginning_of_day..Time.current
                 }
               )
             )
           when "last-payment"
             return(
               records.joins(:credits).where(
                 credits: {
                   dispersed_at:
                     (
                       if first_half
                         1.month.ago.change(day: 16).beginning_of_day..1
                           .month
                           .ago
                           .end_of_month
                       else
                         Time.current.change(day: 1).beginning_of_day..Time
                           .current
                           .change(day: 15)
                           .end_of_day
                       end
                     )
                 }
               )
             )
           when "last-2-payments"
             return(
               records.joins(:credits).where(
                 credits: {
                   dispersed_at:
                     (
                       if first_half
                         1.month.ago.beginning_of_month..1
                           .month
                           .ago
                           .end_of_month
                       else
                         1.month.ago.change(day: 16).beginning_of_day..Time
                           .current
                           .change(day: 15)
                           .end_of_day
                       end
                     )
                 }
               )
             )
           when "last-4-payments"
             return(
               records.joins(:credits).where(
                 credits: {
                   dispersed_at:
                     (
                       if first_half
                         2.months.ago.beginning_of_month..1
                           .month
                           .ago
                           .end_of_month
                       else
                         2.months.ago.change(day: 16).beginning_of_day..Time
                           .current
                           .change(day: 15)
                           .end_of_day
                       end
                     )
                 }
               )
             )
           else
             return records
           end
         end

  filter :first_discount_date_range,
         apply: ->(records, value, _options) do
           Time.zone = "Monterrey"
           first_half = Time.current.day <= 15
           case value.first
           when "last-7-days"
             return(
               records.joins(:credits).where(
                 credits: {
                   first_discount_date:
                     7.days.ago.beginning_of_day..Time.current
                 }
               )
             )
           when "last-payment"
             return(
               records.joins(:credits).where(
                 credits: {
                   first_discount_date:
                     (
                       if first_half
                         1.month.ago.change(day: 16).beginning_of_day..1
                           .month
                           .ago
                           .end_of_month
                       else
                         Time.current.change(day: 1).beginning_of_day..Time
                           .current
                           .change(day: 15)
                           .end_of_day
                       end
                     )
                 }
               )
             )
           when "last-2-payments"
             return(
               records.joins(:credits).where(
                 credits: {
                   first_discount_date:
                     (
                       if first_half
                         1.month.ago.beginning_of_month..1
                           .month
                           .ago
                           .end_of_month
                       else
                         1.month.ago.change(day: 16).beginning_of_day..Time
                           .current
                           .change(day: 15)
                           .end_of_day
                       end
                     )
                 }
               )
             )
           when "last-4-payments"
             return(
               records.joins(:credits).where(
                 credits: {
                   first_discount_date:
                     (
                       if first_half
                         2.months.ago.beginning_of_month..1
                           .month
                           .ago
                           .end_of_month
                       else
                         2.months.ago.change(day: 16).beginning_of_day..Time
                           .current
                           .change(day: 15)
                           .end_of_day
                       end
                     )
                 }
               )
             )
           else
             return records
           end
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
