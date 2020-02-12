import React from 'react'
import { Modal } from 'react-bootstrap'

export default function SignUpForm(props) {
  return(
    <Modal aria-label='Sign Up Modal' show={props.show} onHide={props.handleClose} centered>
      <Modal.Header closeButton>
        <Modal.Title>Sign up</Modal.Title>
      </Modal.Header>
    </Modal>
  )
}