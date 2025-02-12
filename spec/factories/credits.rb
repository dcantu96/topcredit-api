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
    loan { rand(5_000..50_000) }
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
      hr_status { "approved" }
      dispersed_at { FFaker::Time.between(24.months.ago, Time.current) }
      contract_status { "approved" }
      authorization_status { "approved" }
      payroll_receipt_status { "approved" }
    end

    trait :installed do
      installation_status { "installed" }
      installation_date do
        FFaker::Time.between(dispersed_at, dispersed_at + 2.weeks)
      end
    end

    # Create payments after a dispersed credit is created
    after(:create) do |credit|
      if credit.dispersed_at? && credit.installation_date?
        installation_date = credit.installation_date
        term_duration = credit.term_offering.term.duration
        term_duration_type = credit.term_offering.term.duration_type

        payments_to_create =
          Payments.calculate_payments_count(
            Date.today,
            installation_date.to_date,
            term_duration_type,
            term_duration
          )
        next if payments_to_create.zero?

        puts "Creating #{payments_to_create} payments for credit (User: #{credit.borrower.email})"
        payments_to_create.times do |i|
          paid_at =
            Payments.get_next_payment_date(
              installation_date.to_date,
              term_duration_type,
              i
            )
          create(
            :payment, # Use FactoryBot's create method!
            credit: credit,
            paid_at: paid_at,
            amount: credit.amortization, # Ensure your Credit model calculates this
            number: i + 1 # Set number correctly.
          )
        end
      end
    end
  end
end
