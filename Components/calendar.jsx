import React from 'react';
import { Calendar, momentLocalizer } from 'react-big-calendar'
import moment from 'moment'

import 'react-big-calendar/lib/css/react-big-calendar.css'

const localizer = momentLocalizer(moment)

function Event({ event }) {
  return (
    <span>
      <strong>{event.title}</strong>
      {event.desc && ':  ' + event.desc}
    </span>
  )
}

function EventAgenda({ event }) {
  return (
    <span>
      <em style={{ fontWeight: 'bold' }}>{event.title}</em>
      <p>{event.desc}</p>
    </span>
  )
}

export default (props) => {

  var events = props.events.map(m => {
    return {
      title: m.title, 
      desc: m.desc, 
      start: moment(m.start).toDate(),
      end: moment(m.end).toDate()
    }
  });

  return <Calendar 
        localizer={localizer}
        events={events}
        defaultDate={moment(props.defaultDate).toDate()}
        startAccessor="start"
        endAccessor="end"
        style={{ height: props.height }}
      />
}