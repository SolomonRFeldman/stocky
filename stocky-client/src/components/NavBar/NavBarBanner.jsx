import React from 'react'
import './NavBarBanner.css'
import { Nav } from 'react-bootstrap'
import LogOutButton from '../Session/LogOutButton'
import { Link } from 'react-router-dom'

export default function NavBarBanner({ className = '', currentUser }) {
  return(
    <Nav className={`nav-bar-banner ${className}`}>
      <Nav.Link as={Link} to='/'>Portfolio</Nav.Link>
      <Nav.Link as={Link} to='/transactions'>Transactions</Nav.Link>
      <Nav.Link className='active'>{`${currentUser.name}`}</Nav.Link>
      <LogOutButton className='log-out-button' />
    </Nav>
  )
}