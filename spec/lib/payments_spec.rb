# spec/lib/payments_spec.rb

require "rails_helper"
require "payments" # Ensure this line is here if Rails does not autoload lib files for testing

RSpec.describe Payments, type: :lib do
  describe "get next payment date" do
    it "returns the end of the month for monthly term if dispersion is at the beginning of the month" do
      result =
        Payments.get_next_payment_date(DateTime.parse("2024-01-05"), "months")
      expect(result).to eq(DateTime.parse("2024-01-31").at_noon)
    end

    it "advances correctly when duration type is months and first discount date is the last day of the month" do
      result =
        Payments.get_next_payment_date(DateTime.parse("2024-01-31"), "months")
      expect(result).to eq(DateTime.parse("2024-02-29").at_noon)
      result =
        Payments.get_next_payment_date(DateTime.parse("2024-02-29"), "months")
      expect(result).to eq(DateTime.parse("2024-03-31").at_noon)
      result =
        Payments.get_next_payment_date(DateTime.parse("2024-03-31"), "months")
      expect(result).to eq(DateTime.parse("2024-04-30").at_noon)
      result =
        Payments.get_next_payment_date(DateTime.parse("2024-04-30"), "months")
      expect(result).to eq(DateTime.parse("2024-05-31").at_noon)
      result =
        Payments.get_next_payment_date(DateTime.parse("2024-05-31"), "months")
      expect(result).to eq(DateTime.parse("2024-06-30").at_noon)
      result =
        Payments.get_next_payment_date(DateTime.parse("2023-12-31"), "months")
      expect(result).to eq(DateTime.parse("2024-01-31").at_noon)
    end

    it "advances correctly when duration type is months and dispersion date is the 17th" do
      result =
        Payments.get_next_payment_date(DateTime.parse("2018-01-17"), "months")
      expect(result).to eq(DateTime.parse("2018-01-31").at_noon)
      result =
        Payments.get_next_payment_date(DateTime.parse("2018-01-31"), "months")
      expect(result).to eq(DateTime.parse("2018-02-28").at_noon)
      result =
        Payments.get_next_payment_date(DateTime.parse("2018-02-28"), "months")
      expect(result).to eq(DateTime.parse("2018-03-31").at_noon)
      result =
        Payments.get_next_payment_date(DateTime.parse("2018-03-31"), "months")
      expect(result).to eq(DateTime.parse("2018-04-30").at_noon)
      result =
        Payments.get_next_payment_date(DateTime.parse("2018-04-30"), "months")
      expect(result).to eq(DateTime.parse("2018-05-31").at_noon)
      result =
        Payments.get_next_payment_date(DateTime.parse("2018-05-31"), "months")
      expect(result).to eq(DateTime.parse("2018-06-30").at_noon)
    end

    it "advances to the correct day when duration type is two-weeks and first discount date is the last day of the month" do
      result =
        Payments.get_next_payment_date(
          DateTime.parse("2024-01-31"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2024-02-15").at_noon)
      result =
        Payments.get_next_payment_date(
          DateTime.parse("2024-02-15"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2024-02-29").at_noon)
      result =
        Payments.get_next_payment_date(
          DateTime.parse("2024-02-29"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2024-03-15").at_noon)
      result =
        Payments.get_next_payment_date(
          DateTime.parse("2024-03-15"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2024-03-31").at_noon)
      result =
        Payments.get_next_payment_date(
          DateTime.parse("2024-03-31"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2024-04-15").at_noon)
      result =
        Payments.get_next_payment_date(
          DateTime.parse("2024-04-15"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2024-04-30").at_noon)
    end

    it "advances to the correct day when duration type is two-weeks and prev payment is the 4th" do
      result =
        Payments.get_next_payment_date(
          DateTime.parse("2022-05-04"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2022-05-15").at_noon)
      result =
        Payments.get_next_payment_date(
          DateTime.parse("2022-05-04"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2022-05-15").at_noon)
      result =
        Payments.get_next_payment_date(
          DateTime.parse("2022-05-04"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2022-05-15").at_noon)
    end

    it "advances to the correct day when duration type is two-weeks and prev payment is the 15th" do
      result =
        Payments.get_next_payment_date(
          DateTime.parse("2022-05-15"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2022-05-31").at_noon)
      result =
        Payments.get_next_payment_date(
          DateTime.parse("2022-05-31"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2022-06-15").at_noon)
      result =
        Payments.get_next_payment_date(
          DateTime.parse("2022-06-15"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2022-06-30").at_noon)
      result =
        Payments.get_next_payment_date(
          DateTime.parse("2022-06-30"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2022-07-15").at_noon)
    end
  end

  describe "first expected payment date" do
    it "returns the correct first expected payment date for monthly term" do
      result =
        Payments.first_expected_payment_date(
          DateTime.parse("2024-01-05"),
          "months"
        )
      expect(result).to eq(DateTime.parse("2024-01-31").at_noon)
      result =
        Payments.first_expected_payment_date(
          DateTime.parse("2024-01-31"),
          "months"
        )
      expect(result).to eq(DateTime.parse("2024-02-29").at_noon)
      result =
        Payments.first_expected_payment_date(
          DateTime.parse("2024-02-29"),
          "months"
        )
      expect(result).to eq(DateTime.parse("2024-03-31").at_noon)
      result =
        Payments.first_expected_payment_date(
          DateTime.parse("2024-03-20"),
          "months"
        )
      expect(result).to eq(DateTime.parse("2024-04-30").at_noon)
      result =
        Payments.first_expected_payment_date(
          DateTime.parse("2024-03-19"),
          "months"
        )
      expect(result).to eq(DateTime.parse("2024-03-31").at_noon)
    end
    it "returns the correct first expected payment date for two-weeks term" do
      result =
        Payments.first_expected_payment_date(
          DateTime.parse("2024-01-05"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2024-01-31").at_noon)
      result =
        Payments.first_expected_payment_date(
          DateTime.parse("2024-01-31"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2024-02-15").at_noon)
      result =
        Payments.first_expected_payment_date(
          DateTime.parse("2024-02-15"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2024-02-29").at_noon)
      result =
        Payments.first_expected_payment_date(
          DateTime.parse("2024-02-29"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2024-03-15").at_noon)
      result =
        Payments.first_expected_payment_date(
          DateTime.parse("2024-03-07"),
          "two-weeks"
        )
      expect(result).to eq(DateTime.parse("2024-03-31").at_noon)
    end
  end

  describe "credit amount" do
    it "returns the correct credit amount" do
      result = Payments.credit_amount(1_000, 0.1)
      expect(result).to eq(1_100)
      result = Payments.credit_amount(500, 0.2)
      expect(result).to eq(600)
      result = Payments.credit_amount(100, 0.5)
      expect(result).to eq(150)
      result = Payments.credit_amount(36_268.06, 0.522)
      expect(result).to eq(55_199.99)
    end
  end

  describe "calculate amortization" do
    it "returns the correct amortization" do
      result = Payments.amortization(36_268.06, 12, 0.522)
      expect(result).to eq(4_600.0)
      result = Payments.amortization(34_177.21, 18, 0.58)
      expect(result).to eq(3_000.0)
      result = Payments.amortization(5_000.0, 14, 0.58)
      expect(result).to eq(564.29)
    end
  end

  describe "max debt capacity" do
    it "returns the correct maximum loan amount" do
      result = Payments.max_debt_capacity(1_000, 0.3)
      expect(result).to eq(300)
      result = Payments.max_debt_capacity(500, 0.23)
      expect(result).to eq(115.0)
      result = Payments.max_debt_capacity(100, 0.25)
      expect(result).to eq(25.0)
      result = Payments.max_debt_capacity(10_000, 0.3)
      expect(result).to eq(3_000.0)
      result = Payments.max_debt_capacity(23_000, 0.2)
      expect(result).to eq(4_600.0)
    end
  end

  describe "max loan amount" do
    it "returns the correct maximum loan amount" do
      result = Payments.max_loan_amount(300, 7, 0.522)
      expect(result).to eq(1_379.76)
      result = Payments.max_loan_amount(115.0, 7, 0.58)
      expect(result).to eq(509.49)
      result = Payments.max_loan_amount(25.0, 7, 0.58)
      expect(result).to eq(110.76)
      result = Payments.max_loan_amount(3_000, 18, 0.58)
      expect(result).to eq(34_177.22)
      result = Payments.max_loan_amount(4_600, 12, 0.522)
      expect(result).to eq(36_268.07)
    end
  end

  describe "intrest rate with tax" do
    it "returns the correct interest rate with tax" do
      result = Payments.interest_rate_with_tax(0.1)
      expect(result).to eq(0.116)
      result = Payments.interest_rate_with_tax(0.2)
      expect(result).to eq(0.232)
      result = Payments.interest_rate_with_tax(0.45)
      expect(result).to eq(0.522)
      result = Payments.interest_rate_with_tax(0.5)
      expect(result).to eq(0.58)
    end
  end

  describe "full workflow" do
    it "returns the correct loan amount" do
      salary = 10_000
      term_duration = 18
      company_max_debt_capacity = 0.3
      company_rate = 0.50

      max_debt_capacity =
        Payments.max_debt_capacity(salary, company_max_debt_capacity)
      expect(max_debt_capacity).to eq(3_000.0)
      rate_with_tax = Payments.interest_rate_with_tax(company_rate)
      expect(rate_with_tax).to eq(0.58)
      max_loan_amount =
        Payments.max_loan_amount(
          max_debt_capacity,
          term_duration,
          rate_with_tax
        )
      expect(max_loan_amount).to eq(34_177.22)
      amortization =
        Payments.amortization(max_loan_amount, term_duration, rate_with_tax)
      expect(amortization).to eq(3000.0)
    end
  end
end
