class Api::AuthorizedController < Api::ApiController
  before_action :doorkeeper_authorize!

  def current_user
    @current_user ||=
      User.includes(:roles).find(doorkeeper_token.resource_owner_id)
  end
end
