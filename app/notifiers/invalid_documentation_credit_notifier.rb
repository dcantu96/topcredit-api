# To deliver this notification:
#
# InvalidDocumentationCreditNotifier.with(record: @post, message: "New post").deliver(User.all)

class InvalidDocumentationCreditNotifier < ApplicationNotifier
  required_param :handler_name

  notification_methods do
    def message
      "Crédito del cliente #{record.borrower.first_name} marcado con documentación inválida por #{params[:handler_name]}"
    end
  end
end
