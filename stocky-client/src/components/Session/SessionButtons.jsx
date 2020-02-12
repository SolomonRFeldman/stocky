import React from 'react'
import { ButtonToolbar } from 'react-bootstrap'
import SignUpButton from './SignUpButton'

export default function SessionButtons(props) {
  return(
    <ButtonToolbar className={props.className}>
      <SignUpButton />
    </ButtonToolbar>
  )
}