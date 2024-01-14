class Api::MeController < Api::AuthorizedController
  def me
    current_user = User.find(doorkeeper_token.resource_owner_id)
    
    render json: {
      id: current_user.id,
      email: current_user.email,
      firstName: current_user.first_name,
      lastName: current_user.last_name,
      role: current_user.highest_role
    }
  end
end
  