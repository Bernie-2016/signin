import React       from 'react'
import Fluxxor     from 'fluxxor'
import { Input }   from 'react-bootstrap'
import Mailcheck   from 'mailcheck'
import QRCode      from 'qrcode.react'
import $           from 'jquery'
import MaskedInput from 'components/maskedInput'

module.exports = React.createClass
  displayName: 'Event'

  mixins: [Fluxxor.FluxMixin(React), Fluxxor.StoreWatchMixin('EventStore')]

  contextTypes:
    router: React.PropTypes.func

  getStateFromFlux: ->
    store = @props.flux.store('EventStore')

    {
      id: store.id
      title: store.title
      fields: store.fields || []
      eventId: store.event_id
      loaded: store.loaded
      error: store.error
      view: 'FORM'
      suggestion: {}
      showSuggestion: false
      form: false
      qrString: ''
      firstName: ''
      lastName: ''
      phone: ''
      email: ''
      zip: ''
      canText: false
      fieldValues: id: f.id, value: (if f.type is 'checkbox' then false else null) for f in store.fields || []
    }

  checkEmail: (e) ->
    Mailcheck.run(
      email: @state.email
      suggested: (suggestion) =>
        @setState(suggestion: suggestion, showSuggestion: true)
      empty: =>
        @setState(suggestion: {}, showSuggestion: false)
    )

  acceptSuggestion: (e) ->
    return if $(e.target).is('.x')
    @setState(email: @state.suggestion.full)
    @setState(suggestion: {}, showSuggestion: false)

  declineSuggestion: ->
    @setState(suggestion: {}, showSuggestion: false)

  setField: (e) ->
    id = $(e.target).data('id')
    fieldIndex = _.findIndex(@state.fieldValues, id: parseInt(id))
    field = @state.fieldValues[fieldIndex]
    field.value = e.target.value
    @setState(fieldValues: @state.fieldValues.splice(fieldIndex, 1, field))

  setCheck: (e) ->
    id = $(e.target).data('id')
    fieldIndex = _.findIndex(@state.fieldValues, id: parseInt(id))
    field = @state.fieldValues[fieldIndex]
    field.value = $(e.target).is(':checked')
    @setState(fieldValues: @state.fieldValues.splice(fieldIndex, 1, field))

  componentDidMount: ->
    if @props.params.slug
      @props.flux.actions.admin.event.load(
        slug: @props.params.slug
        @props.flux.store('AuthStore').authToken
      )
    $('input').on 'blur', ->
      $(@).removeClass('invalid') unless $(@).is(':invalid')

  submitForm: (e) ->
    e.preventDefault()

    unless $('form').is(':valid')
      alert 'Please complete all required fields.'
      $('input').removeClass('invalid')
      $('input:invalid').addClass('invalid')
      return

    extraFields = @state.fieldValues.map (field) ->
      {
        question_id: field.id
        response: field.value
      }

    data =
      first_name: @state.firstName
      last_name: @state.lastName
      phone: @state.phone
      email: @state.email
      zip: @state.zip
      canText: @state.canText
      extra_fields: [event_id: @state.eventId, questions: extraFields]

    # Stringify basic fields.
    allFields = [
      'first_name'
      'last_name'
      'phone'
      'email'
      'zip'
      'canText'
      'extra_fields'
    ]
    string = JSON.stringify(allFields.map( (key) -> data[key] )).slice(1, -1)
    @setState(view: 'TICKET', qrString: string)

  onPrint: (e) ->
    e.preventDefault()
    windowContent = "<html><body><img src='#{$('canvas')[0].toDataURL()}' style='width: 400px;' /></body></html>"
    printWin = window.open()
    printWin.document.open()
    printWin.document.write(windowContent)
    printWin.document.close()
    printWin.focus()
    printWin.print()
    printWin.close()

  download: (e) ->
    e.target.href = $('canvas')[0].toDataURL()

  render: ->
    <div>
      <section className={"form #{'hidden' unless @state.view is 'FORM'}"}>
        <h2>
          Event Registration
        </h2>
        <hr />
        {if @state.error
          <p className='no-form'>
            No event exists at this URL -- please double-check spelling or contact event staff.
          </p>
        else
          <form className='signup'>
            <Input type='text' placeholder='First Name' required={true} value={@state.firstName} onChange={ (e) => @setState(firstName: e.target.value) } />
            <Input type='text' placeholder='Last Name' required={true} value={@state.lastName} onChange={ (e) => @setState(lastName: e.target.value) } />
            <MaskedInput type='tel' placeholder='Cell Phone #' mask='(111) 111-1111' required={@state.canText} value={@state.phone} onChange={ (e) => @setState(phone: e.target.value) } />
            <Input type='email' placeholder='Email Address' required={true} onBlur={@checkEmail} value={@state.email} onChange={ (e) => @setState(email: e.target.value) } />
            { if @state.showSuggestion
              <div className='email-suggestion' onClick={@acceptSuggestion}>
                <span className='suggestion'>
                  Did you mean {@state.suggestion.address}@<strong>{@state.suggestion.domain}</strong>?
                </span>
                <span className='x' onClick={@declineSuggestion}>X</span>
              </div>
            }

            <MaskedInput name='zip' placeholder='Zip Code' type='tel' mask='11111' required={true} value={@state.zip} onChange={ (e) => @setState(zip: e.target.value) } />

            {for field in @state.fields when field.type is 'text'
              <Input key={field.id} type='text' placeholder={field.title} required={true}  data-id={field.id} onChange={@setField} value={(_.find(@state.fieldValues, id: parseInt(field.id)) || {}).value} />
            }

            <div className='checkboxgroup'>
              <Input type='checkbox' id='canText' onChange={ (e) => @setState(canText: $(e.target).is(':checked')) } />
              <label htmlFor='canText' className='checkbox-label'>
                Receive text msgs from Bernie 2016
                <span className='disclaimer'><br />Mobile alerts from Bernie 2016. Periodic messages. Msg &amp; data rates may apply. <strong>Text STOP to 82623 to stop receiving messages. Text HELP to 82623 for more information.</strong> <a href='https://sync.revmsg.net/terms-and-conditions/4c4b9892-f8fc-4801-b7ea-710fa9225ad4' target='_blank'>Terms &amp; Conditions</a></span>
              </label>
            </div>

            {for field in @state.fields when field.type is 'checkbox'
              <div className='checkboxgroup' key={field.id}>
                <Input type='checkbox' data-id={field.id} onChange={@setCheck} checked={(_.find(@state.fieldValues, id: parseInt(field.id)) || {}).value} />
                <label className='checkbox-label'>
                  {field.title}
                </label>
              </div>
            }

            <a href='#' className='btn block' onClick={@submitForm}>Sign Up</a>
          </form>
        }
      </section>

      <section className={"ticket #{'hidden' unless @state.view is 'TICKET'}"}>
        <h2>Bernie 2016</h2>
        <QRCode value={@state.qrString} size={300} fgColor='#147FD7' />
        <h2>Event Ticket</h2>
        <a className='btn block' onClick={@onPrint}>
          Print
        </a><br />
        <a onClick={@download} className='btn block' download='ticket.png'>
          Save
        </a>
      </section>
    </div>
