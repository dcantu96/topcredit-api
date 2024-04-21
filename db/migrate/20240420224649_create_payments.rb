class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :credit, null: false, foreign_key: true
      t.float :amount, null: false
      t.datetime :paid_at, null: false

      t.timestamps
    end
  end
end
