class ApplicationController < ActionController::Base
  before_action :set_active_storage_url_options

  private

  def set_active_storage_url_options
    ActiveStorage::Current.url_options = { host: request.base_url } # For requests
    if Rails.env.production?
      ActiveStorage::Current.url_options[:protocol] = "https"
    end
  end
  # before_action :configure_permitted_parameters, if: :devise_controller?

  # protected

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
  #   devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])
  # end
end
