json.subject params[:resource]

links = [
  # Federation actor URL
  {
    rel:  'self',
    type: 'application/activity+json',
    href: @user.actor.federated_url,
  },
]

# User profile URL if configured
# TODO: Add a profile controller/action in dummy to test this
if Federails::Configuration.user_profile_url_method
  links.push rel:  'https://webfinger.net/rel/profile-page',
             type: 'text/html',
             href: send(Federails::Configuration.user_profile_url_method, @user)
end

json.links links
