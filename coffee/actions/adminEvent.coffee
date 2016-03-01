import Client    from 'client'
import constants from 'constants/all'

module.exports =
  load: (payload) ->
    @dispatch(constants.ADMIN.EVENT.LOAD)

    success = (response) =>
      @dispatch(constants.ADMIN.EVENT.LOAD_SUCCESS, response)

    failure = (response) =>
      @dispatch(constants.ADMIN.EVENT.LOAD_FAILURE, response)

    Client.get("/events/#{payload.slug}/slug", payload.authToken, {}, success, failure)
