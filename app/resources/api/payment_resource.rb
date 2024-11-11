class Api::PaymentResource < JSONAPI::Resource
  attributes :amount, :number, :paid_at, :created_at, :updated_at
  has_one :credit

  filters :paid_at, :credit_id
  filter :range,
         apply: ->(records, value, _options) do
           Time.zone = "Monterrey"
           first_half = Time.current.day <= 15
           case value.first
           when "last-7-days"
             return(
               records.joins(:payments).where(
                 payments: {
                   paid_at: 7.days.ago.beginning_of_day..Time.current
                 }
               )
             )
           when "last-payment"
             return(
               records.joins(:payments).where(
                 payments: {
                   paid_at:
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
               records.joins(:payments).where(
                 payments: {
                   paid_at:
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
               records.joins(:payments).where(
                 payments: {
                   paid_at:
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
end
