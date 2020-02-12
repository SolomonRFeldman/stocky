import React from 'react'
import ModalButton from '../Modal/ModalButton'
import SignUpForm from './SignUpForm'

export default function SignUpButton(props) {
  const modal = (props) => <SignUpForm {...props} />

  return(
    <ModalButton variant='secondary' aria-label='Sign Up' modal={modal}>Sign Up</ModalButton>
  )
}