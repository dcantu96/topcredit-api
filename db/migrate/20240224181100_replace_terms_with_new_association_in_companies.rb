class ReplaceTermsWithNewAssociationInCompanies < ActiveRecord::Migration[7.1]
  def change
    remove_column :companies, :terms, :string
  end
end
