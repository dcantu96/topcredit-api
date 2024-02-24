class CreateTerms < ActiveRecord::Migration[7.1]
  def change
    create_table :terms do |t|
      t.string :type
      t.integer :duration
      t.string :name

      t.timestamps
    end
    
    add_index :terms, [:duration, :type], unique: true
  end
end
