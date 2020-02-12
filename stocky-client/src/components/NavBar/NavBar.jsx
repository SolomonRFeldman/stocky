import React from 'react'
import { Navbar } from 'react-bootstrap'

export default function NavBar(props) {
  return(
    <Navbar bg='primary' variant='dark' aria-label='Navbar'>
      <Navbar.Brand >STOCKY</Navbar.Brand>
    </Navbar>
  )
}