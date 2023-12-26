class Company < ApplicationRecord
  validates :name, presence: true
  validates :domain, presence: true, format: { with: /\A[a-zA-Z0-9_-]+\.[a-zA-Z]{2,}\z/, message: "must be a valid domain" }
end
