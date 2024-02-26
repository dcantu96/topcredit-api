class Credit < ApplicationRecord
  validates_inclusion_of :status, in: %w( pre-authorized authorized denied )
  belongs_to :borrower, foreign_key: 'user_id', class_name: 'User'
  belongs_to :term
end
