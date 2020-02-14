import React from 'react'
import './NavBarBanner.css'
import { Button, Nav } from 'react-bootstrap'

export default function NavBarBanner({ className = '', currentUser }) {
  return(
    <Nav className={`nav-bar-banner ${className}`}>
      <Nav.Link className='active'>{`${currentUser.name}`}</Nav.Link>
      <Button className='log-out-button' aria-label='Log Out' variant='info'>Log Out</Button>
    </Nav>
  )
}