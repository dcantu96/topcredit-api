class AddInstallationDateToCredits < ActiveRecord::Migration[7.1]
  def change
    add_column :credits, :installation_date, :datetime
  end
end
