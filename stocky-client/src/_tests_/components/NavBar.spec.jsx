import React from 'react'
import { render, fireEvent, within } from '@testing-library/react'
import App from '../../App'
import { act } from 'react-dom/test-utils'
import fetchMock from 'fetch-mock'

let navBar
const mockLoginResponse = { user: { id: 1, name: "Test", token: "totesarealtoken"}}

it('renders the web app name', async() => {
  await act( async() => navBar = render(<App />).getByLabelText('Navbar'))
  expect(navBar).toHaveTextContent('STOCKY')  
})

it('has a sign up button that opens a sign up modal/form', async() => {
  await act(async() => navBar = render(<App />).getByLabelText('Navbar'))
  const signUpButton = within(navBar).getByLabelText('Sign Up')
  await act(async() => fireEvent.click(signUpButton))
  expect(within(document).getByLabelText('Sign Up Modal')).toBeInTheDocument()
})

it('sends the correct data to the server when the signup form is filled and submitted', async() => {
  await act(async() => navBar = render(<App />).getByLabelText('Navbar'))
  const signUpButton = within(navBar).getByLabelText('Sign Up')
  await act(async() => fireEvent.click(signUpButton))
  const signUpForm = within(document).getByLabelText('Sign Up Modal')

  const signInMock = fetchMock.postOnce('/signup', mockLoginResponse)
  
  await act(async() => fireEvent.change(within(signUpForm).getByLabelText('Name'), { target: { value: 'Test' } }))
  await act(async() => fireEvent.change(within(signUpForm).getByLabelText('Email'), { target: { value: 'Test@123.com' } }))
  await act(async() => fireEvent.change(within(signUpForm).getByLabelText('Password'), { target: { value: '123' } }))
  await act(async() => fireEvent.change(within(signUpForm).getByLabelText('Password Confirmation'), { target: { value: '123' } }))
  await act(async() => fireEvent.click(within(signUpForm).getByLabelText('Submit Sign Up')))

  const expectedCall = { user: { name: "Test", email: "Test@123.com", password: "123", password_confirmation: "123" } }
  expect(signInMock).toHaveBeenCalledWith(expectedCall)
})
