# To deliver this notification:
#
# PreAuthorizationsNotifier.with(record: @post, message: "New post").deliver(User.all)

# 2. PreAuthorizationsNotifier
# 2.1 Roles: :admin, :pre_authorizations
# 2.2 Conditions to deliver this notification:
# 2.2.1 - When a user status is set to "pre-authorization"
# 2.2.2 - When a user status is set to "denied"
# 2.2.3 - When a user status is set to "pre-authorized"
# 2.3 Content of the notification:
# 2.3.1 - When 2.2.1: "Nueva solicitud del cliente #{record.first_name} aprobada por #{params[:handler]}"
# 2.3.2 - When 2.2.2: "El cliente #{record.first_name} fue denegado por #{params[:handler]}"
# 2.3.3 - When 2.2.3: "El cliente #{record.first_name} fue pre autorizado por #{params[:handler]}"

class PreAuthorizationsNotifier < ApplicationNotifier
  required_param :handler

  notification_methods do
    def message
      if record.status == "pre-authorization"
        "Nueva solicitud del cliente #{record.first_name} aprobada por #{params[:handler]}"
      elsif record.status == "denied"
        "El cliente #{record.first_name} fue denegado por #{params[:handler]}"
      elsif record.status == "pre-authorized"
        "El cliente #{record.first_name} fue pre autorizado por #{params[:handler]}"
      end
    end
  end
end
