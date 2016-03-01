import AuthStore   from 'stores/authStore'
import EventsStore  from 'stores/eventsStore'
import EventStore   from 'stores/eventStore'

module.exports =
  AuthStore: new AuthStore()
  EventsStore: new EventsStore()
  EventStore: new EventStore()
