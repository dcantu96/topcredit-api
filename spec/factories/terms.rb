FactoryBot.define do
  factory :term do
    sequence(:name) { |n| "#{n * 14} Quincenas" } # Dynamic name
    duration_type { %w[two-weeks months].sample } # Randomly choose
    duration { rand(8...40) }

    after(:build) do |term| #Ensure duration is coherent
      term.name =
        "#{term.duration} #{term.duration_type == "two-weeks" ? "Quincenas" : "Meses"}"
    end

    # You can add traits for specific term types:
    trait :biweekly do
      duration_type { "two-weeks" }
    end

    trait :monthly do
      duration_type { "months" }
    end
  end
end
