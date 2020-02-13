import React, { useState } from 'react'
import { Modal, Form, Button } from 'react-bootstrap'

export default function SignUpForm(props) {

  return(
    <Modal aria-label='Sign Up Modal' show={props.show} onHide={props.handleClose} centered>
      <Modal.Header closeButton>
        <Modal.Title>Sign up</Modal.Title>
      </Modal.Header>
      <Form>
        <Modal.Body>
          <Form.Group>
            <Form.Label>Name</Form.Label>
            <Form.Control id='name' />
          </Form.Group>
          <Form.Group>
            <Form.Label>Email</Form.Label>
            <Form.Control id='email' type='email' />
          </Form.Group>
          <Form.Group>
            <Form.Label>Password</Form.Label>
            <Form.Control id='password' type='password' />
          </Form.Group>
          <Form.Group>
            <Form.Label>Password Confirmation</Form.Label>
            <Form.Control id='password_confirmation' type='password' />
          </Form.Group>
        </Modal.Body>
        <Modal.Footer>
          <Button type='submit'>Sign Up</Button>
        </Modal.Footer>
      </Form>
    </Modal>
  )
}