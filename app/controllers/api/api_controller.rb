class Api::ApiController < ApplicationController
  include JSONAPI::ActsAsResourceController

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def context
    current_user =
      User.includes(:roles).find(doorkeeper_token.resource_owner_id)
    { current_user: current_user }
  end
end
