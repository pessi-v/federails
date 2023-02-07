module Fediverse
  class Notifier
    class << self
      def post_to_inboxes(activity)
        actors = activity.recipients

        Rails.logger.debug 'Nobody to notice' && return if actors.count.zero?

        message = ApplicationController.renderer.new.render(
          template: 'federation/activities/show',
          locals:   { :@activity => activity },
          format:   :json
        )
        actors.each do |actor|
          Rails.logger.debug { "Sending activity ##{activity.id} to #{actor.inbox_url}" }
          Faraday.post actor.inbox_url, message, 'Content-Type' => 'application/json', 'Accept' => 'application/json'
        end
      end
    end
  end
end
