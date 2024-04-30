module Payments
  def self.get_next_payment_date(installation_date, term_duration_type, i)
    installation_date =
      installation_date.to_date unless installation_date.is_a?(Date)

    case term_duration_type
    when "months"
      # Simply advance by the number of months and always return the last day of the month
      return installation_date.advance(months: i).end_of_month
    when "two-weeks"
      return calculate_two_weeks_payment(installation_date, i)
    else
      # Fallback to returning the installation date if an unrecognized term is provided
      return installation_date
    end
  end

  def self.calculate_two_weeks_payment(installation_date, i)
    # Determine the initial payment base: 15th or end of the month
    base_date =
      if installation_date.day <= 15
        installation_date.change(day: 15)
      else
        installation_date.end_of_month
      end

    # Adjust for subsequent cycles
    i.times do
      if base_date.day == 15
        base_date = base_date.end_of_month
      else
        base_date =
          base_date.beginning_of_month.advance(months: 1).change(day: 15)
      end
    end

    base_date
  end

  def self.calculate_payments_count(
    installation_date,
    duration_type,
    total_payments
  )
    installation_date =
      installation_date.to_date unless installation_date.is_a?(Date)
    current_date = Date.today

    first_payment_date =
      get_next_payment_date(installation_date, duration_type, 0)
    payment_count = 0
    next_payment_date = first_payment_date

    # Iterate to count payments until either current date is reached or the total payments limit
    while next_payment_date <= current_date && payment_count < total_payments
      payment_count += 1
      next_payment_date =
        get_next_payment_date(installation_date, duration_type, payment_count)
    end

    payment_count
  end
end
