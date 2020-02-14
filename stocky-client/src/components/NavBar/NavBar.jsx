import React from 'react'
import { Navbar } from 'react-bootstrap'
import SessionBanner from './SessionBanner'

export default function NavBar(props) {
  return(
    <Navbar bg='primary' variant='dark' expand='lg' aria-label='Navbar'>
      <Navbar.Brand >STOCKY</Navbar.Brand>
      <Navbar.Toggle />
      <Navbar.Collapse>
        <SessionBanner />
      </Navbar.Collapse>
    </Navbar>
  )
}