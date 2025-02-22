FactoryBot.define do
  factory :company do
    transient { fake_name { FFaker::Company.name } }
    name { fake_name }
    domain do
      fake_domain = fake_name.strip.gsub(/\s+/, "-")

      fake_domain = fake_domain.gsub(/\s+/, "-")

      fake_domain = fake_domain.gsub(/[!@#$%^&*()+=\[\]{}|;:"'<>?\/`~_,]/, "")
      fake_domain = fake_domain.gsub(/^-+|-+$/, "")
      fake_domain = fake_domain.gsub(/-{2,}/, "-")

      "#{fake_domain.downcase}.com"
    end
    employee_salary_frequency { %w[bi-monthly monthly].sample }
    rate { FFaker::Random.rand(0.2..0.7).round(3) } # Random rate between 0.2 and 0.7
    borrowing_capacity { FFaker::Random.rand(0.2..0.4).round(3) } # Random capacity

    # Transient attributes don't get saved to the database, but are
    # available during factory creation.
    transient do
      term_count { 2 } # Default to creating 2 associated terms
    end

    # after(:create) is crucial for associations.  :build would only
    # build the associated objects, not create them.
    after(:create) do |company, evaluator|
      term_duration_type =
        (
          if company.employee_salary_frequency == "bi-monthly"
            "bi-monthly"
          else
            "monthly"
          end
        )

      # Fetch available terms of the correct type.
      available_terms = Term.where(duration_type: term_duration_type)

      # Handle the case where there aren't enough terms.
      if available_terms.count < evaluator.term_count
        raise "Not enough #{term_duration_type} terms available. Create more in seeds.rb or use a smaller term_count."
      end

      # Randomly select the required number of terms, without replacement.
      selected_terms = available_terms.sample(evaluator.term_count)

      # Create term offerings, assigning the pre-existing terms.

      selected_terms.each { |term| company.term_offerings.create(term: term) }
    end
  end
end
