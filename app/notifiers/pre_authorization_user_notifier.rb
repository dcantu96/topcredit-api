# To deliver this notification:
#
# PreAuthorizationUserNotifier.with(record: @post, message: "New post").deliver(User.all)

class PreAuthorizationUserNotifier < ApplicationNotifier
  required_param :handler_name

  notification_methods do
    def message
      "Solicitud del cliente #{record.first_name} aprobada por #{params[:handler_name]}"
    end
  end
end
