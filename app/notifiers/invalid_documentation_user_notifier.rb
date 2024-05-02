# To deliver this notification:
#
# InvalidDocumentationUserNotifier.with(record: @post, message: "New post").deliver(User.all)

class InvalidDocumentationUserNotifier < ApplicationNotifier
  required_param :handler_name

  notification_methods do
    def message
      "Solicitud del cliente #{record.first_name} marcada con documentación inválida por #{params[:handler_name]}"
    end
  end
end
