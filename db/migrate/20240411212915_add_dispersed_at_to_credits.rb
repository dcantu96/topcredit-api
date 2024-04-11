class AddDispersedAtToCredits < ActiveRecord::Migration[7.1]
  def change
    add_column :credits, :dispersed_at, :datetime
  end
end
