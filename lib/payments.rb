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
