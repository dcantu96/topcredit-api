class Api::UserResource < JSONAPI::Resource
  attributes :first_name, :last_name, :email, :phone, :password, :created_at, :updated_at
  has_many :credits
  
  def fetchable_fields
    super - [:password]
  end
end