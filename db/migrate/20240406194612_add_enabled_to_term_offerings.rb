class AddEnabledToTermOfferings < ActiveRecord::Migration[7.1]
  def change
    add_column :term_offerings, :enabled, :boolean, default: true, null: false
  end
end
