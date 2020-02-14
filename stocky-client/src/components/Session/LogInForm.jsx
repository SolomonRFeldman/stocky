import React from 'react'
import { Modal, Button, Form } from 'react-bootstrap'

export default function LogInForm(props) {
  return(
    <Modal aria-label='Log In Form' show={props.show} onHide={props.handleClose} centered>
      <Modal.Header>Log In</Modal.Header>
      <Form>
        <Modal.Body>
          <Form.Group controlId='email'>
            <Form.Label>Email</Form.Label>
            <Form.Control placeholder='Email' type='email' />
          </Form.Group>
          <Form.Group controlId='password'>
            <Form.Label>Password</Form.Label>
            <Form.Control placeholder='Password' type='password' />
          </Form.Group>
        </Modal.Body>
        <Modal.Footer>
          <Button aria-label='Submit Log In' type='button'>Log In</Button>
        </Modal.Footer>
      </Form>
    </Modal>
  )
}