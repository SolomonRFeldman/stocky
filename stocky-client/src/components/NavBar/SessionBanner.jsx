import React from 'react'
import SessionButtons from '../Session/SessionButtons'
import { useSelector } from 'react-redux'
import NavBarBanner from './NavBarBanner'

export default function SessionBanner(props) {
  const currentUser = useSelector(state => state.currentUser)

  return(
    currentUser.id ?
      <NavBarBanner className='ml-auto' currentUser={currentUser} /> :
      <SessionButtons className='ml-auto' />
  )
}