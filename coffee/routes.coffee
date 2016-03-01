import React          from 'react'
import { Route }      from 'react-router'

import App            from 'components/app'
import Event          from 'components/event'
import Auth           from 'components/auth'
import Authenticated  from 'components/authenticated'
import AdminEvents    from 'components/admin/events/index'
import AdminEvent     from 'components/admin/events/show'
import AdminNewEvent  from 'components/admin/events/new'
import AdminEditEvent from 'components/admin/events/edit'

module.exports = (
  <Route component={App}>
    <Route component={Authenticated}>
      <Route path='/admin/events/new' component={AdminNewEvent} />
      <Route path='/admin/events/campaign' component={AdminEvents} />
      <Route path='/admin/events/internal' component={AdminEvents} />
      <Route path='/admin/events/:id/edit' component={AdminEditEvent} />
      <Route path='/admin/events/:id' component={AdminEvent} />
      <Route path='/admin' component={AdminEvents} />
    </Route>

    <Route path='login' component={Auth} />
    <Route path='callback' component={Auth} />
    <Route path='/:slug' component={Event} />
    <Route path='/' component={Event} />
  </Route>
)
