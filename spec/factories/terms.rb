FactoryBot.define do
  factory :term do
    transient do
      unique_duration do
        existing_durations = Term.pluck(:duration)
        random_duration = FFaker::Random.rand(8...40)
        loop do
          break unless existing_durations.include?(random_duration)
          random_duration = FFaker::Random.rand(8...40)
        end
        random_duration
      end
    end

    duration_type { %w[two-weeks months].sample } # Randomly choose
    duration { unique_duration }

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
