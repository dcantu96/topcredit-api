module Payments
  def self.first_expected_payment_date(dispersed_at, term_duration_type)
    # Determine the initial payment base: 15th or end of the month
    # if duration is two-weeks, the first payment is the 15th or the end of the month
    #   if dispersed before the 4th of the month, the first payment is the 15th else if dispersed before the 20th, the first payment is the end of the month, else the first payment is the 15th of the next month
    # else if the payment is before the 20th, the first payment is the end of the month, else the first payment is the end of next the month

    if term_duration_type == "two-weeks"
      if dispersed_at.at_noon.day < 4
        return dispersed_at.change(day: 15).at_noon
      end
      return dispersed_at.end_of_month.at_noon if dispersed_at.at_noon.day < 20
      return dispersed_at.advance(months: 1).change(day: 15).at_noon
    end

    return dispersed_at.end_of_month.at_noon if dispersed_at.day < 20
    dispersed_at.advance(months: 1).end_of_month.at_noon
  end

  def self.get_next_payment_date(prev_payment_date, term_duration_type)
    case term_duration_type
    when "months"
      if prev_payment_date.at_noon != prev_payment_date.end_of_month.at_noon
        return prev_payment_date.end_of_month.at_noon
      end
      return prev_payment_date.advance(months: 1).end_of_month.at_noon
    when "two-weeks"
      return get_next_two_week_payment(prev_payment_date)
    else
      # Fallback to returning the installation date if an unrecognized term is provided
      return first_discount_date
    end
  end

  def self.get_next_two_week_payment(prev_payment_date)
    # Determine the initial payment base: 15th or end of the month

    if prev_payment_date.day < 15
      return prev_payment_date.change(day: 15).at_noon
    end

    if prev_payment_date.at_noon != prev_payment_date.end_of_month.at_noon
      return prev_payment_date.end_of_month.at_noon
    end

    prev_payment_date.advance(months: 1).change(day: 15).at_noon
  end

  def self.max_loan_amount(
    salary,
    company_max_debt_capacity,
    annual_interest_rate,
    term_duration,
    term_duration_type
  )
    period_interest_rate =
      period_interest_rate(annual_interest_rate, term_duration_type)

    employee_max_salary_debt_capacity =
      (salary * company_max_debt_capacity).round(2) # Use salary directly

    max_loan =
      employee_max_salary_debt_capacity /
        (
          period_interest_rate * (1 + period_interest_rate)**term_duration /
            ((1 + period_interest_rate)**term_duration - 1)
        )
    max_loan.round(2)
  end

  def self.interest_rate_with_tax(rate)
    (rate * 1.16).round(4)
  end

  def self.helpful_function(
    principal,
    annual_interest_rate,
    term_duration,
    term_duration_type
  )
    emi =
      emi(principal, annual_interest_rate, term_duration, term_duration_type)

    amortization_schedule = []
    remaining_balance = principal
    current_date = Date.today.beginning_of_month

    (1..term_duration).each do |payment_number|
      interest_paid = remaining_balance * period_interest_rate
      principal_paid = emi - interest_paid
      remaining_balance -= principal_paid

      amortization_schedule << {
        month_year: current_date.strftime("%B %Y"),
        starting_balance: remaining_balance + principal_paid,
        interest_paid: interest_paid.round(2),
        principal_paid: principal_paid.round(2),
        emi: emi.round(2),
        ending_balance: remaining_balance.round(2)
      }

      if term_duration_type.downcase == "months"
        current_date = current_date.next_month
      elsif term_duration_type.downcase == "two-weeks"
        current_date = current_date + 14 # Add 14 days for two weeks
      end
    end

    amortization_schedule
  end

  def self.period_interest_rate(annual_interest_rate, term_duration_type)
    if term_duration_type.downcase == "months"
      annual_interest_rate / 12.0
    elsif term_duration_type.downcase == "two-weeks"
      annual_interest_rate / 26.0
    else
      raise ArgumentError,
            "Invalid term_duration_type. Must be 'months' or 'two-weeks'."
    end
  end

  def self.emi(
    principal,
    annual_interest_rate,
    term_duration,
    term_duration_type
  )
    period_interest_rate =
      period_interest_rate(annual_interest_rate, term_duration_type)

    (
      principal *
        (period_interest_rate * (1 + period_interest_rate)**term_duration) /
        ((1 + period_interest_rate)**term_duration - 1)
    ).round(2)
  end

  def self.credit_amount(
    principal,
    annual_interest_rate,
    term_duration,
    term_duration_type
  )
    (
      emi(principal, annual_interest_rate, term_duration, term_duration_type) *
        term_duration
    ).round(2)
  end
end
