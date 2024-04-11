class AddInstallationStatusToCredits < ActiveRecord::Migration[7.1]
  def change
    add_column :credits, :installation_status, :string
  end
end
