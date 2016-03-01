import Client      from 'client'
import constants   from 'constants/all'
import auth        from 'actions/auth'
import adminEvents  from 'actions/adminEvents'
import adminEvent   from 'actions/adminEvent'

module.exports =
  auth: auth
  admin:
    events: adminEvents
    event: adminEvent
