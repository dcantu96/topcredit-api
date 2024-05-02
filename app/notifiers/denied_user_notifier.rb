# To deliver this notification:
#
# DeniedUserNotifier.with(record: @post, message: "New post").deliver(User.all)

class DeniedUserNotifier < ApplicationNotifier
  required_param :handler_name

  notification_methods do
    def message
      "Solicitud del cliente #{record.first_name} denegada por #{params[:handler_name]}"
    end
  end
end
