CONTRACT_FILENAME = "contract.png"
AUTHORIZATION_FILENAME = "authorization.png"
PAYROLL_RECEIPT_FILENAME_CREDIT = "payroll_receipt.png"
DISPERSION_RECEIPT_FILENAME = "dispersion_receipt.png"

FactoryBot.define do
  factory :credit do
    association :term_offering

    borrower do
      company = term_offering.company
      create(:user, :pre_authorized, custom_domain: company.domain)
    end

    status { "new" }
    loan { FFaker::Random.rand(5_000..50_000) }

    # Trait for a credit with documents (using a file)
    trait :with_documents do
      transient { file_path { Rails.root.join("db", "assets", "150.png") } }

      status { "pending" }
      contract_status { "pending" }
      authorization_status { "pending" }
      payroll_receipt_status { "pending" }

      after(:build) do |credit, evaluator|
        credit.contract.attach(
          io: File.open(evaluator.file_path, "rb"),
          filename: CONTRACT_FILENAME,
          content_type: "image/png"
        )

        credit.authorization.attach(
          io: File.open(evaluator.file_path, "rb"),
          filename: AUTHORIZATION_FILENAME,
          content_type: "image/png"
        )

        credit.payroll_receipt.attach(
          io: File.open(evaluator.file_path, "rb"),
          filename: PAYROLL_RECEIPT_FILENAME_CREDIT,
          content_type: "image/png"
        )

        credit.dispersion_receipt.attach(
          io: File.open(evaluator.file_path, "rb"),
          filename: DISPERSION_RECEIPT_FILENAME,
          content_type: "image/png"
        )
      end
    end

    trait :authorized do
      with_documents

      status { "authorized" }
      contract_status { "approved" }
      authorization_status { "approved" }
      payroll_receipt_status { "approved" }
    end

    trait :hr_approved do
      authorized

      hr_status { "approved" }
      first_discount_date do
        Payments.first_expected_payment_date(
          FFaker::Time.between(24.months.ago, Time.current),
          term_offering.term.duration_type
        )
      end
    end

    trait :dispersed do
      hr_approved

      status { "dispersed" }
      dispersed_at do
        FFaker::Time.between(first_discount_date, first_discount_date + 3.days)
      end

      after(:create) do |credit|
        credit
          .payments
          .where("expected_at <= ?", Time.current)
          .each do |payment|
            payment.update!(
              hr_confirmed_at: payment.expected_at.advance(hours: -2),
              paid_at: payment.expected_at,
              amount: credit.amortization
            )
          end
      end
    end

    trait :with_missing_payments do
      dispersed

      transient { num_missing_payments { rand(1..3) } }

      after(:create) do |credit, evaluator|
        missing_payments =
          credit
            .payments
            .where("expected_at <=?", Time.current)
            .order(number: :desc)
            .limit(evaluator.num_missing_payments)

        missing_payments.each do |payment|
          payment.update!(paid_at: nil, amount: nil, hr_confirmed_at: nil)
        end
      end
    end

    trait :defaulted do
      dispersed

      status { "defaulted" }

      after(:create) do |credit|
        total_payments = credit.payments.count
        num_missing_payments = (total_payments * 0.5).ceil + 1 # At least 50% + 1

        missing_payments =
          credit.payments.order(:number).limit(num_missing_payments)

        missing_payments.each do |payment|
          payment.update!(paid_at: nil, amount: nil, hr_confirmed_at: nil)
        end
      end
    end
  end
end
