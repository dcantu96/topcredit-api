class User < ApplicationRecord
  rolify  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validate :email_of_company_domain
  
  has_many :access_grants,
         class_name: 'Doorkeeper::AccessGrant',
         foreign_key: :resource_owner_id,
         dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
         class_name: 'Doorkeeper::AccessToken',
         foreign_key: :resource_owner_id,
         dependent: :delete_all # or :destroy if you need callbacks
  
  has_many :credits, dependent: :destroy
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true
  validates :status, inclusion: { in: ['pending', 'approved', 'invalid_documentation', 'denied'] }

  # Calculate the highest possible role for the user
  def highest_role
    available_roles = roles.pluck(:name)
    
    if available_roles.include? 'admin'
      'admin'
    end
    if available_roles.include? 'requests'
      'requests'
    end
  end
  
  private

  def email_of_company_domain
    if Company.find_by(domain: email.split('@').last).nil?
      errors.add(:email, :invalid_domain)
    end
  end
end
