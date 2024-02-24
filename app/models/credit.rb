class Credit < ApplicationRecord
  belongs_to :borrower, foreign_key: 'user_id', class_name: 'User'
  belongs_to :term
end
