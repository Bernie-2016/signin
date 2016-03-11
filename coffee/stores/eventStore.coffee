import Fluxxor   from 'fluxxor'
import constants from 'constants/all'

module.exports = Fluxxor.createStore
  initialize: (options) ->
    @id = null
    @title = null
    @earlyAccess = null
    @color = null
    @fields = []
    @loaded = false
    @error = false

    @bindActions(constants.ADMIN.EVENT.LOAD, @onLoadEvent)
    @bindActions(constants.ADMIN.EVENT.LOAD_SUCCESS, @onLoadEventSuccess)
    @bindActions(constants.ADMIN.EVENT.LOAD_FAILURE, @onLoadEventFailure)

  onLoadEvent: ->
    @loaded = false
    @emit('change')

  onLoadEventSuccess: (response) ->
    if response is null
      @error = true
    else
      @id = response.id
      @title = response.title
      @earlyAccess = response.early_access
      @color = response.color
      @fields = response.questions
      @loaded = true
    @emit('change')

  onLoadEventFailure: (response) ->
    @error = true
    @emit('change')
