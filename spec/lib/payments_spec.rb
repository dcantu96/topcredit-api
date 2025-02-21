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
      result = Payments.credit_amount(1_000, 0.1, 12, "months")
      expect(result).to eq(1_055.04)
      result = Payments.credit_amount(500, 0.2, 12, "months")
      expect(result).to eq(555.84)
      result = Payments.credit_amount(100, 0.5, 12, "months")
      expect(result).to eq(129.12)
      result = Payments.credit_amount(36_268.06, 0.522, 12, "months")
      expect(result).to eq(47_319.84)
      result = Payments.credit_amount(34_177.21, 0.58, 18, "months")
      expect(result).to eq(51_944.04)
    end
  end

  describe "calculate emi" do
    it "returns the correct emi" do
      result = Payments.emi(36_268.06, 0.522, 12, "months")
      expect(result).to eq(3_943.32)
      result = Payments.emi(34_177.21, 0.58, 18, "months")
      expect(result).to eq(2_885.78)
      result = Payments.emi(5_000.0, 0.58, 14, "months")
      expect(result).to eq(499.75)
    end
  end

  describe "max loan amount" do
    it "returns the correct maximum loan amount" do
      result = Payments.max_loan_amount(300, 0.3, 0.522, 7, "months")
      expect(result).to eq(533.27)
    end
  end

  describe "interest rate with tax" do
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
      term_duration_type = "months"
      company_max_debt_capacity_rate = 0.3
      company_rate = 0.50
      rate_with_tax = Payments.interest_rate_with_tax(company_rate)

      expect(rate_with_tax).to eq(0.58)
      max_loan_amount =
        Payments.max_loan_amount(
          salary,
          company_max_debt_capacity_rate,
          rate_with_tax,
          term_duration,
          term_duration_type
        )
      expect(max_loan_amount).to eq(35_529.91)
      amortization =
        Payments.emi(
          max_loan_amount,
          rate_with_tax,
          term_duration,
          term_duration_type
        )
      expect(amortization).to eq(3000.0)
    end
  end
end
