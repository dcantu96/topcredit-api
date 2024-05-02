# To deliver this notification:
#
# PreAuthorizedUserNotifier.with(record: @post, message: "New post").deliver(User.all)

class PreAuthorizedUserNotifier < ApplicationNotifier
  required_param :handler_name

  notification_methods do
    def message
      "Solicitud del cliente #{record.first_name} pre autorizada por #{params[:handler_name]}"
    end
  end
end
