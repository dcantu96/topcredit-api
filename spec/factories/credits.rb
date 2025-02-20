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
    contract_status { "pending" }
    authorization_status { "pending" }
    payroll_receipt_status { "pending" }

    # Trait for a credit with documents (using a file)
    trait :with_documents do
      transient { file_path { Rails.root.join("db", "assets", "150.png") } }
      status { "pending" }
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

    trait :dispersed do
      status { "dispersed" }
      dispersed_at { FFaker::Time.between(24.months.ago, Time.current) }
      contract_status { "approved" }
      authorization_status { "approved" }
      payroll_receipt_status { "approved" }
    end

    trait :hr_approved do
      hr_status { "approved" }
    end

    after(:create) do |credit|
      return if credit.status != "dispersed" || credit.hr_status != "approved"

      # update payments that have already passed
      credit
        .payments
        .where("expected_at <= ?", Time.current)
        .each do |payment|
          payment.update!(
            paid_at: payment.expected_at,
            amount: credit.amortization
          )
        end
    end
  end
end
