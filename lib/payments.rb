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
    date,
    installation_date,
    duration_type,
    total_payments
  )
    installation_date =
      installation_date.to_date unless installation_date.is_a?(Date)
    current_date = date

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

  def self.credit_amount(loan_amount, rate)
    # Calculate the credit amount based on the loan amount and the rate
    (loan_amount * (1 + rate)).round(2)
  end

  def self.amortization(loan_amount, payments, rate)
    ((credit_amount(loan_amount, rate)) / payments).round(2)
  end

  def self.max_debt_capacity(salary, company_max_debt_capacity)
    # Calculate the maximum debt capacity based on the salary and company limit
    (salary * company_max_debt_capacity).round(2)
  end

  def self.max_loan_amount(max_debt_capacity, payments, rate)
    # Calculate the maximum loan amount based on the debt capacity and the duration
    (max_debt_capacity * payments / (1 + rate)).round(2)
  end

  def self.interest_rate_with_tax(rate)
    (rate * 1.16).round(4)
  end
end
