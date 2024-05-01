class Api::NotificationResource < JSONAPI::Resource
  # The recipient relationship would be serialized with a data node including
  # the `type` and `id` of the taggable instance
  attributes :created_at, :updated_at, :message, :read_at, :seen_at
  model_name "Noticed::Notification"
  has_one :recipient, polymorphic: true, always_include_linkage_data: true

  filter :type
end
