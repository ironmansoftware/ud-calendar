import React from 'react';
import {Calendar, Views} from 'react-big-calendar'
import localizer from 'react-big-calendar/lib/localizers/moment'
import moment from 'moment'

import 'react-big-calendar/lib/css/react-big-calendar.css'

const momentLocalizer = localizer(moment)


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

  const defaultDate = events[0].start;

  return <Calendar 
        localizer={momentLocalizer}
        events={events}
        defaultDate={defaultDate}
        view={Views.DAY}
        startAccessor="start"
        endAccessor="end"
        components={{
          event: Event,
          agenda: {
            event: EventAgenda,
          },
        }}
      />
}