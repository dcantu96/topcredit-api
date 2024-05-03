# To deliver this notification:
#
# AuthorizedCreditNotifier.with(record: @post, message: "New post").deliver(User.all)

class AuthorizedCreditNotifier < ApplicationNotifier
  required_param :handler_name

  notification_methods do
    def message
      "Crédito del cliente #{record.borrower.first_name} autorizado por #{params[:handler_name]}"
    end
  end
end
