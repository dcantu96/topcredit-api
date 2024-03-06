class AddReasonToCredits < ActiveRecord::Migration[7.1]
  def change
    add_column :credits, :reason, :string
  end
end
