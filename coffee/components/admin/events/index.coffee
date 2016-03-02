import React                        from 'react'
import Fluxxor                      from 'fluxxor'
import { History, Link }            from 'react-router'
import { Table, Thead, Th, Tr, Td } from 'reactable'
import Loader                       from 'react-loader'
import $                            from 'jquery'
import moment                       from 'moment'

module.exports = React.createClass
  displayName: 'AdminEvents'

  mixins: [Fluxxor.FluxMixin(React), Fluxxor.StoreWatchMixin('AuthStore', 'EventsStore'), History]

  getStateFromFlux: ->
    store = @props.flux.store('EventsStore')

    {
      events: store.events
      loaded: store.loaded
      error: store.error
    }

  componentDidMount: ->
    unless @state.loaded
      setTimeout =>
        @props.flux.actions.admin.events.load(@props.flux.store('AuthStore').authToken) 

  deleteEvent: (e) ->
    e.preventDefault()
    if confirm('Are you sure you want to delete this event? This action cannot be undone.')
      @props.flux.actions.admin.events.destroy(
        authToken: @props.flux.store('AuthStore').authToken
        id: $(e.target).data('id')
      )

  render: ->
    <Loader loaded={@state.loaded} top='35%'>
      <Link to={'/admin/events/new'} className='btn'>New Event</Link>
      <Table className='table table-striped' filterable={['name']} noDataText='No events.'>
        <Thead>
          <Th column='name'>
            <strong>Name</strong>
          </Th>
          <Th column='date'>
            <strong>Date</strong>
          </Th>
          <Th column='signups'>
            <strong>Signups</strong>
          </Th>
          <Th column='edit'>
            <strong>Edit</strong>
          </Th>
          <Th column='delete'>
            <strong>Delete</strong>
          </Th>
        </Thead>
        {for evt in @state.events
          <Tr key={evt.id}>
            <Td column='name'>
              <Link to={"/admin/events/#{evt.id}"}>{evt.name}</Link>
            </Td>
            <Td column='date'>
              {moment(evt.date).format('MM/DD/YYYY')}
            </Td>
            <Td column='signups'>
              {evt.signups_count}
            </Td>
            <Td column='edit'>
              <Link to={"/admin/events/#{evt.id}/edit"}>Edit</Link>
            </Td>
            <Td column='delete'>
              <a href='#' data-id={evt.id} onClick={@deleteEvent}>Delete</a>
            </Td>
          </Tr>
        }
      </Table>
    </Loader>
