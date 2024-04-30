class Api::AuthController < Api::ApiController
  def resend_confirmation_instructions
    user = User.find_by(email: params[:email])
    user.resend_confirmation_instructions if user.present? && !user.confirmed?
    render json: {}, status: :ok
  end
end
