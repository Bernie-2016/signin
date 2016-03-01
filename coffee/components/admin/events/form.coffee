import React                            from 'react'
import { Row, Col, Input, ButtonInput } from 'react-bootstrap'
import DatePicker                       from 'react-bootstrap-datetimepicker'
import $                                from 'jquery'
import moment                           from 'moment'
import randomId                         from 'random-id'

module.exports = React.createClass
  displayName: 'AdminEventForm'

  setQuestionTitle: (e) ->
    index = $(e.target).data('index')
    questions = @props.questions
    questions[index].title = e.target.value
    @props.set(questions: questions)

  setQuestionType: (e) ->
    index = $(e.target).data('index')
    questions = @props.questions
    questions[index].type = e.target.value
    @props.set(questions: questions)

  addQuestion: (e) ->
    e.preventDefault()
    questions = @props.questions
    questions.push { rid: randomId(), title: '', type: 'text' }
    @props.set(questions: questions)

  removeQuestion: (e) ->
    e.preventDefault()
    index = $(e.target).data('index')
    questions = @props.questions
    questions.splice(index, 1)
    @props.set(questions: questions)

  render: ->
    <form onSubmit={@props.submit}>
      
      <Input type='text' label='Name' placeholder='Event name' value={@props.name} onChange={ (e) => @props.set(name: e.target.value) } />
      <label className='control-label'>Date</label>
      <DatePicker inputFormat='MM/DD/YYYY' format='YYYY-MM-DD' dateTime={@props.date} onChange={ (value) => @props.set(date: moment(value)) } />
      <br />
      <Input type='text' label='Slug' placeholder='Event slug' value={@props.slug} onChange={ (e) => @props.set(slug: e.target.value) } addonBefore='https://bernietickets.com/' />
      <label className='control-label'>Custom Fields</label>
      {for question, index in @props.questions
        <Row key={question.id || question.rid}>
          <Col xs={5}>
            <Input type='text' label='Field title' placeholder='Field title' value={question.title} data-index={index} onChange={@setQuestionTitle} />
          </Col>
          <Col xs={5}>
            <Input type='select' label='Field type' data-index={index} onChange={@setQuestionType}>
              <option value='text'>Text</option>
              <option value='checkbox'>Checkbox</option>
            </Input>
          </Col>
          <Col xs={2}>
            <label className='control-label' />
            <ButtonInput className='remove' data-index={index} onClick={@removeQuestion} value='Remove' />
          </Col>
        </Row>
      }
      <ButtonInput onClick={@addQuestion} value='Add Field' />
      <ButtonInput bsStyle='primary' type='submit' value={@props.submitText} />
    </form>
