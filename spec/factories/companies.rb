FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "Empresa #{n}" }
    sequence(:domain) { |n| "company#{n}.com" }
    employee_salary_frequency { %w[biweekly monthly].sample }
    rate { rand(0.2..0.7).round(3) } # Random rate between 0.2 and 0.7
    borrowing_capacity { rand(0.2..0.4).round(3) } # Random capacity

    # Transient attributes don't get saved to the database, but are
    # available during factory creation.
    transient do
      term_count { 2 } # Default to creating 2 associated terms
    end

    # after(:create) is crucial for associations.  :build would only
    # build the associated objects, not create them.
    after(:create) do |company, evaluator|
      term_duration_type =
        company.employee_salary_frequency == "biweekly" ? "two-weeks" : "months"

      # Fetch available terms of the correct type.
      available_terms = Term.where(duration_type: term_duration_type)

      # Handle the case where there aren't enough terms.
      if available_terms.count < evaluator.term_count
        raise "Not enough #{term_duration_type} terms available. Create more in seeds.rb or use a smaller term_count."
      end

      # Randomly select the required number of terms, without replacement.
      selected_terms = available_terms.sample(evaluator.term_count)

      # Create term offerings, assigning the pre-existing terms.
      selected_terms.each do |term|
        create(:term_offering, company: company, term: term)
      end
    end
  end
end
