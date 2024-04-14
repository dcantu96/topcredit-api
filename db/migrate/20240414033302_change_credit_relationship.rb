class ChangeCreditRelationship < ActiveRecord::Migration[7.1]
  def up
    # Add the new column without NOT NULL constraint initially
    add_reference :credits, :term_offering, foreign_key: true

    # Temporary disable the foreign key constraint during data update
    # Adjust the table name `term_offerings` as necessary based on your actual table name
    execute "ALTER TABLE credits DISABLE TRIGGER ALL;"

    # Update the term_offering_id based on associated user data
    Credit.includes(:borrower).find_each do |credit|
      if credit.borrower
        company_domain = credit.borrower.email.split('@').last
        company = Company.find_by(domain: company_domain)
        term_offering = TermOffering.find_or_create_by!(company_id: company.id, term_id: credit.term_id)
        credit.update(term_offering_id: term_offering.id) if term_offering
      end
    end

    # Re-enable foreign key constraints
    execute "ALTER TABLE credits ENABLE TRIGGER ALL;"

    # Change the column to NOT NULL only after all data has been updated
    change_column :credits, :term_offering_id, :bigint, null: false

    # Assuming `term` is no longer needed
    remove_reference :credits, :term, foreign_key: true
  end

  def down
    # Re-add the term column to the credits table
    add_reference :credits, :term, foreign_key: true

    # Temporarily disable the foreign key constraint during data restoration
    execute "ALTER TABLE credits DISABLE TRIGGER ALL;"

    # Restore term_id from term_offering_id
    Credit.includes(:term_offering).find_each do |credit|
      if credit.term_offering
        credit.update_column(:term_id, credit.term_offering.term_id) # using update_column to avoid callbacks and validations
      end
    end

    # Re-enable foreign key constraints
    execute "ALTER TABLE credits ENABLE TRIGGER ALL;"

    # Remove the term_offering reference column
    remove_reference :credits, :term_offering, foreign_key: true, null: false
  end
end
