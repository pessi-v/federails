json.version '2.0'
# FIXME: Use configuration values when created
json.software name:    Federails::Configuration.app_name,
              version: Federails::Configuration.app_version
json.protocols [
  'activitypub',
]
# FIXME: When server is in good shape: update outbounds
# http://nodeinfo.diaspora.software/ns/schema/2.0 for possible values
json.services inbound:  [],
              outbound: []
# FIXME: Don't hardcode this
json.openRegistrations true
json.usage users: {
  total:          Federails::Configuration.user_model.count,
  activeMonth:    Federails::Configuration.user_model.where(created_at: ((30.days.ago)...Time.current)).count,
  activeHalfyear: Federails::Configuration.user_model.where(created_at: ((180.days.ago)...Time.current)).count,
}
json.metadata({})
