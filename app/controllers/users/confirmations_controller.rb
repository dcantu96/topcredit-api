class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    token = params[:confirmation_token]
    user = resource_class.confirm_by_token(token)
    
    if user.active_for_authentication?
      redirect_to success_redirect_url
    else
      redirect_to failure_redirect_url
    end
  end

  private

  def success_redirect_url
    if Rails.env.production?
      "https://topcredit.mx/confirmation-success"
    else
      "http://localhost:3000/confirmation-success"
    end
  end

  def failure_redirect_url
    if Rails.env.production?
      "https://topcredit.mx/confirmation-failure"
    else
      "http://localhost:3000/confirmation-failure"
    end
  end
end