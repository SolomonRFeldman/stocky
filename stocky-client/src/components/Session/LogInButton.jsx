import React from 'react'
import ModalButton from '../Modal/ModalButton'
import LogInForm from './LogInForm'

export default function LogInButton(props) {
  const modal = (props) => <LogInForm {...props} />

  return(
    <ModalButton className={props.className} aria-label='Log In' variant='info' modal={modal}>Log In</ModalButton>
  )
}