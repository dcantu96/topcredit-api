# frozen_string_literal: true

Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (requires ORM extensions installed).
  # Check the list of supported ORMs here: https://github.com/doorkeeper-gem/doorkeeper#orms
  orm :active_record

  # This block will be called to check whether the resource owner is authenticated or not.
  resource_owner_authenticator do
    current_user || warden.authenticate!(scope: :user)
  end

  resource_owner_from_credentials do |routes|
    user = User.find_for_database_authentication(email: params[:email])
    if user&.valid_for_authentication? {
         user.valid_password?(params[:password])
       } && user&.active_for_authentication?
      request.env["warden"].set_user(user, scope: :user, store: false)
      user
    end
  end

  allow_blank_redirect_uri true

  skip_authorization { true }

  api_only

  allow_blank_redirect_uri true
  access_token_expires_in 4.hours
  grant_flows %w[password]
end
