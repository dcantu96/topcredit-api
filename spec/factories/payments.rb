FactoryBot.define do
  factory :payment do
    credit
    amount { credit.amortization } # Use the credit's amortization
    sequence(:number) { |n| n } # Sequential payment number
    paid_at { FFaker::Time.between(credit.dispersed_at, Time.current) }
  end
end
