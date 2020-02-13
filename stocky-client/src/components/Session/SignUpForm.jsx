import React, { useState } from 'react'
import { Modal, Form, Button } from 'react-bootstrap'
import { postRequest } from '../../apiRequests'
import { useDispatch } from 'react-redux'

export default function SignUpForm(props) {
  const dispatch = useDispatch()
  const addCurrentUser = payload => dispatch({ type: 'ADD_CURRENT_USER', payload})

  const [formData, setFormData] = useState({ name: '', email: '', password: '', password_confirmation: ''})
  const handleChange = event => setFormData({ ...formData, [event.target.id]: event.target.value })

  const handleSubmit = event => {
    event.preventDefault()

    return postRequest('/signup', { user: formData }).then(user => {
      addCurrentUser({ id: user.id, name: user.name })
      localStorage.token = user.token
      props.handleClose()
    })
  }

  return(
    <Modal aria-label='Sign Up Modal' show={props.show} onHide={props.handleClose} centered>
      <Modal.Header closeButton>
        <Modal.Title>Sign up</Modal.Title>
      </Modal.Header>
      <Form onSubmit={handleSubmit}>
        <Modal.Body>
          <Form.Group controlId='name'>
            <Form.Label>Name</Form.Label>
            <Form.Control placeholder='Name' onChange={handleChange} />
          </Form.Group>
          <Form.Group controlId='email'>
            <Form.Label>Email</Form.Label>
            <Form.Control placeholder='Email' type='email' onChange={handleChange} />
          </Form.Group>
          <Form.Group controlId='password'>
            <Form.Label>Password</Form.Label>
            <Form.Control placeholder='Password' type='password' onChange={handleChange} />
          </Form.Group>
          <Form.Group controlId='password_confirmation'>
            <Form.Label>Password Confirmation</Form.Label>
            <Form.Control placeholder='Password Confirmation' type='password' onChange={handleChange} />
          </Form.Group>
        </Modal.Body>
        <Modal.Footer>
          <Button aria-label='Submit Sign Up' type='submit'>Sign Up</Button>
        </Modal.Footer>
      </Form>
    </Modal>
  )
}