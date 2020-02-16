import React, { useState } from 'react'
import { Modal, Button, Form } from 'react-bootstrap'
import { postRequest } from '../../apiRequests'
import { useDispatch } from 'react-redux'

export default function LogInForm(props) {
  const dispatch = useDispatch()
  const addCurrentUser = payload => dispatch({ type: 'ADD_CURRENT_USER', payload})

  const [formData, setFormData] = useState({ name: '', email: '', password: '', password_confirmation: ''})
  const handleChange = event => setFormData({ ...formData, [event.target.id]: event.target.value })

  const handleSubmit = event => {
    event.preventDefault()

    return postRequest('/login', { user: formData }).then(user => {
      addCurrentUser({ id: user.id, name: user.name })
      localStorage.token = user.token
      
      props.handleClose()
    })
  }

  return(
    <Modal aria-label='Log In Form' show={props.show} onHide={props.handleClose} centered>
      <Modal.Header closeButton>
        <Modal.Title>Log In</Modal.Title>
      </Modal.Header>
      <Form onSubmit={handleSubmit}>
        <Modal.Body>
          <Form.Group controlId='email'>
            <Form.Label>Email</Form.Label>
            <Form.Control placeholder='Email' type='email' onChange={handleChange} />
          </Form.Group>
          <Form.Group controlId='password'>
            <Form.Label>Password</Form.Label>
            <Form.Control placeholder='Password' type='password' onChange={handleChange} />
          </Form.Group>
        </Modal.Body>
        <Modal.Footer>
          <Button aria-label='Submit Log In' type='submit'>Log In</Button>
        </Modal.Footer>
      </Form>
    </Modal>
  )
}