class CreateTerms < ActiveRecord::Migration[7.1]
  def change
    create_table :terms do |t|
      t.string :duration_type
      t.integer :duration
      t.string :name

      t.timestamps
    end
    
    add_index :terms, [:duration, :duration_type], unique: true
  end
end
