context = true unless context == false
json.set! '@context', 'https://www.w3.org/ns/activitystreams' if context

json.id Federails::Engine.routes.url_helpers.actor_activity_url activity.actor, activity
json.type activity.action
json.actor activity.actor.federated_url
json.to ['https://www.w3.org/ns/activitystreams#Public']
json.cc [activity.actor.followers_url]
json.object activity.entity.federated_url
