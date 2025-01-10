class Api::EventsController < Api::AuthorizedController
  before_action :set_filters, only: [:index]

  def index
    events = Noticed::Event.where(@filters)
    render json: serialize(events)
  end

  private

  # Parse filters from JSON:API request parameters
  def set_filters
    permitted_params = params.permit(filter: [:type], page: %i[limit number])

    @filters = {
      type: permitted_params.dig(:filter, :type)&.split(",") # Split comma-separated values
    }
  end

  # Serialize the events for JSON:API compliance
  # Serialize the events for JSON:API compliance
  def serialize(events)
    {
      data:
        events.map do |event|
          {
            id: event.id.to_s,
            type: "events",
            attributes: {
              name: event.type,
              message: events.first.notifications.first.message,
              createdAt: event.created_at
            },
            relationships: {
              record: serialize_record(event.record)
            }
          }
        end
    }
  end

  def serialize_record(record)
    return nil unless record

    {
      data: {
        id: record.id.to_s,
        type: record.class.name.underscore.pluralize,
        attributes: record.attributes
      }
    }
  end
end
