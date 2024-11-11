class Payment < ApplicationRecord
  belongs_to :credit

  validates_presence_of :credit
  validates_presence_of :amount
  validates_presence_of :paid_at
  validates_presence_of :number
  validates_numericality_of :amount, greater_than: 0
  validates_numericality_of :number, greater_than: 0
  validates_uniqueness_of :number, scope: :credit_id

  validate :credit_must_be_installed

  def credit_must_be_installed
    unless credit.present? && credit.installation_status == "installed"
      errors.add(:credit, "must be installed")
    end
  end
end
