import React from 'react'
import { Modal } from 'react-bootstrap'

export default function LogInForm(props) {
  return(
    <Modal aria-label='Log In Form' show={props.show} onHide={props.handleClose} centered>
      <Modal.Header>Log In</Modal.Header>
    </Modal>
  )
}