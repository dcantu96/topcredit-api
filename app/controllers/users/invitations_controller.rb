class Users::InvitationsController < Devise::InvitationsController
  respond_to :json
  before_action :configure_permitted_parameters, if: :devise_controller?

  def update
    raw_invitation_token = update_resource_params[:invitation_token]
    self.resource = accept_resource
    invitation_accepted = resource.errors.empty?

    yield resource if block_given?

    if invitation_accepted
      resource.confirm
      if resource.class.allow_insecure_sign_in_after_accept
        if resource.active_for_authentication?
          render json: {
                   message: "User has been successfully invited and confirmed."
                 },
                 status: 200
        else
          render json: {
                   message:
                     "User has been successfully invited but confirmation is required."
                 },
                 status: 200
        end
      else
        if resource.active_for_authentication?
          render json: {
                   message: "User has been successfully invited and confirmed."
                 },
                 status: 200
        else
          render json: {
                   message:
                     "User has been successfully invited but confirmation is required."
                 },
                 status: 200
        end
      end
    else
      render json: { messages: resource.errors.full_messages }, status: 422
    end
  end

  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)
    resource
  end

  protected

  # Permit the new params here.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :invite,
      keys: %i[first_name last_name role]
    )
  end
end
