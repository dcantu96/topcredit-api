class Payment < ApplicationRecord
  belongs_to :credit

  validates_presence_of :credit
  validates_presence_of :amount
  validates_presence_of :paid_at
  validates_presence_of :number
  validates_numericality_of :amount, greater_than: 0
  validates_numericality_of :number, greater_than: 0
  validates_uniqueness_of :number, scope: :credit_id
end
