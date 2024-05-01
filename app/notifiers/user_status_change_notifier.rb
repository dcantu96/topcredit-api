# To deliver this notification:
# UserStatusChangeNotifier.with(record: @user, handled_by: current_user).deliver(User.all)

class UserStatusChangeNotifier < ApplicationNotifier
  # Add your delivery methods
  #
  # deliver_by :email do |config|
  #   config.mailer = "UserMailer"
  #   config.method = "new_post"
  # end
  #
  # bulk_deliver_by :slack do |config|
  #   config.url = -> { Rails.application.credentials.slack_webhook_url }
  # end
  #
  # deliver_by :custom do |config|
  #   config.class = "MyDeliveryMethod"
  # end

  # Add required params
  #
  required_param :handler

  notification_methods do
    def message
      "El estatus del cliente #{record.first_name} fue actualizado a #{record.status} por #{params[:handler]}"
    end
  end
end
