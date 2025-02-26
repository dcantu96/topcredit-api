IDENTITY_DOC_FILENAME = "identity_document.png"
BANK_STATEMENT_FILENAME = "bank_statement.png"
PAYROLL_RECEIPT_FILENAME = "payroll_receipt.png"
PROOF_OF_ADDRESS_FILENAME = "proof_of_address.png"

FactoryBot.define do
  factory :user do
    first_name { FFaker::NameMX.first_name }
    last_name { FFaker::NameMX.last_name }
    phone { FFaker::PhoneNumberMX.phone_number }
    password { "123456" } # Set a default password
    password_confirmation { "123456" }
    confirmed_at { Time.current } # Automatically confirm users
    status { "new" }
    rfc { FFaker::IdentificationMX.rfc }
    salary { FFaker::Random.rand(2_000..10_000) }
    address_line_one { FFaker::Address.street_address }
    address_line_two { FFaker::Address.secondary_address }
    city { FFaker::AddressMX.municipality }
    state do
      %w[
        AGU
        BCN
        BCS
        CAM
        CHP
        CHH
        COA
        COL
        DUR
        GUA
        GRO
        HID
        JAL
        MEX
        MIC
        MOR
        NAY
        NLE
        OAX
        PUE
        QUE
        ROO
        SLP
        SIN
        SON
        TAB
        TAM
        TLA
        VER
        YUC
        ZAC
      ].sample
    end
    postal_code { FFaker::AddressMX.zip_code }
    country { "Mexico" }
    employee_number { FFaker::Number.number(digits: 5).to_s }
    bank_account_number { FFaker::Number.number(digits: 18).to_s }

    trait :admin do
      after(:build) { |user| user.add_role(:admin) }
    end

    trait :requests do
      after(:build) { |user| user.add_role(:requests) }
    end

    trait :hr do
      after(:build) { |user| user.add_role(:hr) }
    end

    trait :authorizations do
      after(:build) { |user| user.add_role(:authorizations) }
    end

    trait :dispersions do
      after(:build) { |user| user.add_role(:dispersions) }
    end

    transient { custom_domain { nil } }

    after(:build) do |user, evaluator|
      if user.email.blank?
        user.email =
          "#{user.first_name.downcase}.#{user.last_name.downcase}@#{evaluator.custom_domain || Company.all.sample.domain}"
      end
    end

    # ... add other role traits similarly

    # Trait for a user with documents (using a file)
    trait :with_documents do
      transient { file_path { Rails.root.join("db", "assets", "150.png") } }
      identity_document_status { "pending" }
      bank_statement_status { "pending" }
      payroll_receipt_status { "pending" }
      proof_of_address_status { "pending" }
      after(:build) do |user, evaluator| #Use build here
        user.identity_document.attach(
          io: File.open(evaluator.file_path, "rb"),
          filename: IDENTITY_DOC_FILENAME,
          content_type: "image/png"
        )

        user.bank_statement.attach(
          io: File.open(evaluator.file_path, "rb"),
          filename: BANK_STATEMENT_FILENAME,
          content_type: "image/png"
        )

        user.payroll_receipt.attach(
          io: File.open(evaluator.file_path, "rb"),
          filename: PAYROLL_RECEIPT_FILENAME,
          content_type: "image/png"
        )

        user.proof_of_address.attach(
          io: File.open(evaluator.file_path, "rb"),
          filename: PROOF_OF_ADDRESS_FILENAME,
          content_type: "image/png"
        )
      end
    end

    # Trait for a user with approved documents
    trait :approved_docs do
      trait :with_documents
      identity_document_status { "approved" }
      bank_statement_status { "approved" }
      payroll_receipt_status { "approved" }
      proof_of_address_status { "approved" }
    end

    # Trait for a user with rejected documents
    trait :rejected_docs do
      trait :with_documents
      status { "invalid-documentation" }
      identity_document_status { "rejected" }
      bank_statement_status { "rejected" }
      payroll_receipt_status { "rejected" }
      proof_of_address_status { "rejected" }
    end

    trait :pre_authorized do
      trait :approved_docs
      status { "pre-authorized" }
      identity_document_status { "approved" }
      bank_statement_status { "approved" }
      payroll_receipt_status { "approved" }
      proof_of_address_status { "approved" }
    end
    # ... other user traits (e.g., :with_credit)
  end
end
