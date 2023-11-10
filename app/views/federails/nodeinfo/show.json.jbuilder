json.version '2.0'
# FIXME: Use configuration values when created
json.software name:    'co2',
              version: '0.1'
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
  total:          User.count,
  activeMonth:    User.where(created_at: ((30.days.ago)...Time.current)).count,
  activeHalfyear: User.where(created_at: ((180.days.ago)...Time.current)).count,
}
json.metadata({})
