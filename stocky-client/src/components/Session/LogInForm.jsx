import React, { useState } from 'react'
import { Modal, Button, Form } from 'react-bootstrap'
import { postRequest } from '../../apiRequests'
import { useDispatch } from 'react-redux'

export default function LogInForm(props) {
  const dispatch = useDispatch()
  const addCurrentUser = payload => dispatch({ type: 'ADD_CURRENT_USER', payload})

  const [formData, setFormData] = useState({ name: '', email: '', password: '', password_confirmation: ''})
  const handleChange = event => setFormData({ ...formData, [event.target.id]: event.target.value })
  const [errors, setErrors] = useState({})

  const handleSubmit = event => {
    event.preventDefault()

    return postRequest('/login', { user: formData }).then(user => {
      addCurrentUser({ id: user.id, name: user.name })
      localStorage.token = user.token
      
      props.handleClose()
    }).catch(response => {
      response.status === 400 ?
        response.json().then(errors => setErrors(errors)) :
        setErrors({...errors, server: 'failed to reach server'})
    })
  }

  const handleHide = () => {
    setErrors({})
    props.handleClose()
  }

  return(
    <Modal aria-label='Log In Form' show={props.show} onHide={handleHide} centered>
      <Modal.Header closeButton>
        <Modal.Title>Log In</Modal.Title>
      </Modal.Header>
      <Form onSubmit={handleSubmit}>
        <Modal.Body>
          <Form.Group controlId='email'>
            <Form.Label>Email</Form.Label>
            <Form.Control placeholder='Email' type='email' onChange={handleChange} isInvalid={errors.authentication_error} />
            <Form.Control.Feedback type="invalid">Invalid Email or Password</Form.Control.Feedback>
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