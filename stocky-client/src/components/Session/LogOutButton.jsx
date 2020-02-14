import React from 'react'
import { Button } from 'react-bootstrap'
import { useDispatch } from 'react-redux'

export default function LogOutButton(props) {
  const dispatch = useDispatch()
  const handleClick = () => {
    dispatch({ type: 'REMOVE_CURRENT_USER' })
    localStorage.clear()
  }

  return(
    <Button className={props.className} aria-label='Log Out' variant='info' onClick={handleClick}>Log Out</Button>
  )
}