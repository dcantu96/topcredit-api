# To deliver this notification:
#
# PendingUserNotifier.with(record: @post, message: "New post").deliver(User.all)

class PendingUserNotifier < ApplicationNotifier
  notification_methods do
    def message
      "Un nuevo cliente #{record.first_name} ha solicitado un crédito"
    end
  end
end
