import React             from 'react'
import Fluxxor           from 'fluxxor'
import { History, Link } from 'react-router'
import { Row, Col }      from 'react-bootstrap'
import Loader            from 'react-loader'
import _                 from 'lodash'
import moment            from 'moment'
import Form              from 'components/admin/events/form'

module.exports = React.createClass
  displayName: 'AdminEditEvent'

  contextTypes:
    router: React.PropTypes.func

  mixins: [Fluxxor.FluxMixin(React), Fluxxor.StoreWatchMixin('AuthStore', 'EventsStore'), History]

  getStateFromFlux: ->
    store = @props.flux.store('EventsStore')
    evt = _.find(store.events, id: parseInt(@props.params.id)) || {}

    {
      name: evt.name
      date: if evt.date then moment(evt.date) else moment()
      slug: evt.slug
      questions: evt.questions || []
      loaded: store.loaded
      error: store.error
      updatedId: store.updatedId
    }

  set: (payload) ->
    @setState(payload)

  submit: (e) ->
    e.preventDefault()

    @props.flux.actions.admin.events.update(
      authToken: @props.flux.store('AuthStore').authToken
      id: @props.params.id
      data:
        event:
          name: @state.name
          date: @state.date.toISOString()
          slug: @state.slug
          questions_attributes: @state.questions
    )

  componentDidMount: ->
    @props.flux.actions.admin.events.load(@props.flux.store('AuthStore').authToken) unless @state.loaded

  componentDidUpdate: ->
    @history.pushState(null, "/admin/events/#{@state.updatedId}") if @state.updatedId

  render: ->
    <Loader loaded={@state.loaded} top='35%'>
      <Row>
        <Col md={6} xs={12}>
          <h1>Edit Event</h1>
          <Form name={@state.name} date={@state.date.format('YYYY-MM-DD')} slug={@state.slug} questions={@state.questions} set={@set} submit={@submit} submitText='Update Event' /> 
        </Col>
      </Row>
    </Loader>
