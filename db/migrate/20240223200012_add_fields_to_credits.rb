class AddFieldsToCredits < ActiveRecord::Migration[7.1]
  def change
    add_column :credits, :status, :string
    add_column :credits, :loan, :float
    add_reference :credits, :term, foreign_key: true
  end
end
