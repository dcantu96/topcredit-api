class CreateTermOfferings < ActiveRecord::Migration[7.1]
  def change
    create_table :term_offerings do |t|
      t.references :company, null: false, foreign_key: true
      t.references :term, null: false, foreign_key: true

      t.timestamps
    end
  end
end
