class Overrides::DirectUploadsController < ActiveStorage::DirectUploadsController
  skip_before_action :verify_authenticity_token

  # This is also where we wanna add some sort of auth to this endpoint
  # So not everyone can get a link to upload a file into our storage service
end
