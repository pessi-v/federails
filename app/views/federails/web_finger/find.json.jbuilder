json.subject params[:resource]
json.links [
  {
    rel:  'http://webfinger.net/rel/profile-page',
    type: 'text/html',
    href: user_url(@user),
  },
  {
    rel:  'self',
    type: 'application/activity+json',
    href: @user.actor.federated_url,
  },
]
