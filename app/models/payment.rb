class Payment < ApplicationRecord
  belongs_to :credit

  validates_presence_of :credit
  validates_presence_of :amount
  validates_presence_of :paid_at
  validates_numericality_of :amount, greater_than: 0
end
