# To deliver this notification:
#
# PendingUserNotifier.with(record: @post, message: "New post").deliver(User.all)

class PendingCreditNotifier < ApplicationNotifier
  notification_methods do
    def message
      "Crédito del cliente #{record.borrower.first_name} está pendiente de aprobación"
    end
  end
end
