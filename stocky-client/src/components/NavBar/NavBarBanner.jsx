import React from 'react'
import './NavBarBanner.css'
import { Nav } from 'react-bootstrap'
import LogOutButton from '../Session/LogOutButton'

export default function NavBarBanner({ className = '', currentUser }) {
  return(
    <Nav className={`nav-bar-banner ${className}`}>
      <Nav.Link className='active'>{`${currentUser.name}`}</Nav.Link>
      <LogOutButton className='log-out-button' />
    </Nav>
  )
}