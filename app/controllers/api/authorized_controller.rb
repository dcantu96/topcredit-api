class Api::AuthorizedController < Api::ApiController
  before_action :doorkeeper_authorize!
end
