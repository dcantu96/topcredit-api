# spec/lib/payments_spec.rb

require "rails_helper"
require "payments" # Ensure this line is here if Rails does not autoload lib files for testing

RSpec.describe Payments, type: :lib do
  describe "get next payment date" do
    it "returns the end of the month for monthly term if installation is at the beginning of the month" do
      result =
        Payments.get_next_payment_date(Date.parse("2024-01-05"), "months", 0)
      expect(result).to eq(Date.parse("2024-01-31"))
    end

    it "advances correctly when duration type is months and installation date is the last day of the month" do
      result =
        Payments.get_next_payment_date(Date.parse("2024-01-31"), "months", 1)
      expect(result).to eq(Date.parse("2024-02-29"))
      result =
        Payments.get_next_payment_date(Date.parse("2024-01-31"), "months", 2)
      expect(result).to eq(Date.parse("2024-03-31"))
      result =
        Payments.get_next_payment_date(Date.parse("2024-01-31"), "months", 3)
      expect(result).to eq(Date.parse("2024-04-30"))
      result =
        Payments.get_next_payment_date(Date.parse("2024-01-31"), "months", 4)
      expect(result).to eq(Date.parse("2024-05-31"))
      result =
        Payments.get_next_payment_date(Date.parse("2024-01-31"), "months", 5)
      expect(result).to eq(Date.parse("2024-06-30"))
    end

    it "advances correctly when duration type is months and installation date is the 17th" do
      result =
        Payments.get_next_payment_date(Date.parse("2018-01-17"), "months", 0)
      expect(result).to eq(Date.parse("2018-01-31"))
      result =
        Payments.get_next_payment_date(Date.parse("2018-01-17"), "months", 1)
      expect(result).to eq(Date.parse("2018-02-28"))
      result =
        Payments.get_next_payment_date(Date.parse("2018-01-17"), "months", 2)
      expect(result).to eq(Date.parse("2018-03-31"))
      result =
        Payments.get_next_payment_date(Date.parse("2018-01-17"), "months", 3)
      expect(result).to eq(Date.parse("2018-04-30"))
      result =
        Payments.get_next_payment_date(Date.parse("2018-01-17"), "months", 4)
      expect(result).to eq(Date.parse("2018-05-31"))
      result =
        Payments.get_next_payment_date(Date.parse("2018-01-17"), "months", 5)
      expect(result).to eq(Date.parse("2018-06-30"))
    end

    it "advances to the correct day when duration type is two-weeks and installation date is the last day of the month" do
      result =
        Payments.get_next_payment_date(Date.parse("2024-01-31"), "two-weeks", 0)
      expect(result).to eq(Date.parse("2024-01-31"))
      result =
        Payments.get_next_payment_date(Date.parse("2024-01-31"), "two-weeks", 1)
      expect(result).to eq(Date.parse("2024-02-15"))
      result =
        Payments.get_next_payment_date(Date.parse("2024-01-31"), "two-weeks", 2)
      expect(result).to eq(Date.parse("2024-02-29"))
      result =
        Payments.get_next_payment_date(Date.parse("2024-01-31"), "two-weeks", 3)
      expect(result).to eq(Date.parse("2024-03-15"))
      result =
        Payments.get_next_payment_date(Date.parse("2024-01-31"), "two-weeks", 4)
      expect(result).to eq(Date.parse("2024-03-31"))
      result =
        Payments.get_next_payment_date(Date.parse("2024-01-31"), "two-weeks", 5)
      expect(result).to eq(Date.parse("2024-04-15"))
    end

    it "advances to the correct day when duration type is two-weeks and installation date is the 4th" do
      result =
        Payments.get_next_payment_date(Date.parse("2022-05-04"), "two-weeks", 0)
      expect(result).to eq(Date.parse("2022-05-15"))
      result =
        Payments.get_next_payment_date(Date.parse("2022-05-04"), "two-weeks", 1)
      expect(result).to eq(Date.parse("2022-05-31"))
      result =
        Payments.get_next_payment_date(Date.parse("2022-05-04"), "two-weeks", 2)
      expect(result).to eq(Date.parse("2022-06-15"))
    end

    it "advances to the correct day when duration type is two-weeks and installation date is the 15th" do
      result =
        Payments.get_next_payment_date(Date.parse("2022-05-15"), "two-weeks", 0)
      expect(result).to eq(Date.parse("2022-05-15"))
      result =
        Payments.get_next_payment_date(Date.parse("2022-05-15"), "two-weeks", 1)
      expect(result).to eq(Date.parse("2022-05-31"))
      result =
        Payments.get_next_payment_date(Date.parse("2022-05-15"), "two-weeks", 2)
      expect(result).to eq(Date.parse("2022-06-15"))
      result =
        Payments.get_next_payment_date(Date.parse("2022-05-15"), "two-weeks", 3)
      expect(result).to eq(Date.parse("2022-06-30"))
      result =
        Payments.get_next_payment_date(Date.parse("2022-05-15"), "two-weeks", 4)
      expect(result).to eq(Date.parse("2022-07-15"))
    end
  end

  describe "calculate payments count" do
    it "returns valid count when duration type is months" do
      result =
        Payments.calculate_payments_count(Date.parse("2024-04-20"), "months", 3)
      expect(result).to eq(0)
      result =
        Payments.calculate_payments_count(Date.parse("2024-03-23"), "months", 3)
      expect(result).to eq(1)
      result =
        Payments.calculate_payments_count(Date.parse("2024-03-31"), "months", 3)
      expect(result).to eq(1)
      result =
        Payments.calculate_payments_count(Date.parse("2024-01-31"), "months", 3)
      expect(result).to eq(3)
    end

    it "returns valid count when duration type is two-weeks" do
      result =
        Payments.calculate_payments_count(
          Date.parse("2024-04-20"),
          "two-weeks",
          3
        )
      expect(result).to eq(0)
      result =
        Payments.calculate_payments_count(
          Date.parse("2024-03-23"),
          "two-weeks",
          3
        )
      expect(result).to eq(2)
      result =
        Payments.calculate_payments_count(
          Date.parse("2024-03-31"),
          "two-weeks",
          3
        )
      expect(result).to eq(2)
      result =
        Payments.calculate_payments_count(
          Date.parse("2024-01-31"),
          "two-weeks",
          6
        )
      expect(result).to eq(6)
    end

    it "returns the maximum number of payments when the total possible payments is greater than the loan duration" do
      result =
        Payments.calculate_payments_count(Date.parse("2024-01-31"), "months", 2)
      expect(result).to eq(2)
      result =
        Payments.calculate_payments_count(Date.parse("2019-04-06"), "months", 9)
      expect(result).to eq(9)
      result =
        Payments.calculate_payments_count(
          Date.parse("2024-01-31"),
          "two-weeks",
          4
        )
      expect(result).to eq(4)
    end
  end
end
