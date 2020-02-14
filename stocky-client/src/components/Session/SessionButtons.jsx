import React from 'react'
import { ButtonToolbar } from 'react-bootstrap'
import SignUpButton from './SignUpButton'
import LogInButton from './LogInButton'

export default function SessionButtons(props) {
  return(
    <ButtonToolbar className={props.className}>
      <LogInButton className='mr-2'/>
      <SignUpButton />
    </ButtonToolbar>
  )
}