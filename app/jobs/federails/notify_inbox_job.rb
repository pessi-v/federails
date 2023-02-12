require 'fediverse/notifier'

class NotifyInboxJob < ApplicationJob
  queue_as :default

  def perform(activity)
    activity.reload
    Fediverse::Notifier.post_to_inboxes(activity)
  end
end
