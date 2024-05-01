# To deliver this notification:
#
# RequestsNotifier.with(record: @post, message: "New post").deliver(User.all)

# 1. RequestsNotifier
# 1.1 Roles: :admin, :requests
# 1.2 Conditions to deliver this notification:
# 1.2.1 - When a user status is set to "pending"
# 1.2.2 - When a user status is set to "pre-authorization"
# 1.2.3 - When a user status is set to "denied"
# 1.2.4 - When a user status is set to "invalid-documentation"
# 1.3 Content of the notification:
# 1.3.1 - When 1.2.1: "Un nuevo cliente #{record.first_name} ha solicitado un crédito"
# 1.3.2 - When 1.2.2: "La solicitud del cliente #{record.first_name} fue aprobada por #{params[:handler]}"
# 1.3.3 - When 1.2.3: "La solicitud del cliente #{record.first_name} fue denegada por #{params[:handler]}"
# 1.3.4 - When 1.2.4: "La solicitud del cliente #{record.first_name} fue marcada como inválida por #{params[:handler]}"

class RequestsNotifier < ApplicationNotifier
  notification_methods do
    def message
      if record.status == "pending"
        "Un nuevo cliente #{record.first_name} ha solicitado un crédito"
      elsif record.status == "pre-authorization"
        "La solicitud del cliente #{record.first_name} fue aprobada por #{params[:handler]}"
      elsif record.status == "denied"
        "La solicitud del cliente #{record.first_name} fue denegada por #{params[:handler]}"
      elsif record.status == "invalid-documentation"
        "La solicitud del cliente #{record.first_name} fue marcada como inválida por #{params[:handler]}"
      end
    end
  end
end
