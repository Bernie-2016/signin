import React             from 'react'
import Fluxxor           from 'fluxxor'
import { History, Link } from 'react-router'
import { Row, Col }      from 'react-bootstrap'
import moment            from 'moment'
import Form              from 'components/admin/events/form'

module.exports = React.createClass
  displayName: 'AdminNewEvent'

  mixins: [Fluxxor.FluxMixin(React), Fluxxor.StoreWatchMixin('AuthStore', 'EventsStore'), History]

  getStateFromFlux: ->
    store = @props.flux.store('EventsStore')

    {
      title: ''
      date: moment()
      slug: ''
      questions: []
      error: store.error
      createdId: store.createdId
    }

  set: (payload) ->
    @setState(payload)

  submit: (e) ->
    e.preventDefault()
    @props.flux.actions.admin.events.create(
      authToken: @props.flux.store('AuthStore').authToken
      data:
        event:
          name: @state.name
          date: new Date(@state.date).toISOString()
          slug: @state.slug
          questions_attributes: @state.questions
    )

  componentDidUpdate: ->
    @history.pushState(null, "/admin/events/#{@state.createdId}") if @state.createdId

  render: ->
    <Row>
      <Col md={6} xs={12}>
        <h1>New Event</h1>
        <Form name={@state.name} date={@state.date.format('YYYY-MM-DD')} slug={@state.slug} questions={@state.questions} set={@set} submit={@submit} submitText='Create Event' /> 
      </Col>
    </Row>
