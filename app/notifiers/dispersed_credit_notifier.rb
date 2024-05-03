# To deliver this notification:
#
# DeniedCreditNotifier.with(record: @post, message: "New post").deliver(User.all)

class DispersedCreditNotifier < ApplicationNotifier
  required_param :handler_name

  notification_methods do
    def message
      "Crédito del cliente #{record.borrower.first_name} dispersado por #{params[:handler_name]}"
    end
  end
end
