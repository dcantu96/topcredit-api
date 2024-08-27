class AddActivePropertyToCredits < ActiveRecord::Migration[7.1]
  def change
    add_column :credits, :hr_status, :string
  end
end
