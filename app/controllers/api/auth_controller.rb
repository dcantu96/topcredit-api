class Api::AuthController < Api::ApiController
  def resend_confirmation_instructions
    user = User.find_by(email: params[:email])
    if user.present? && !user.confirmed?
      user.resend_confirmation_instructions
    end
    render json: {}, status: :ok
  end
end
  