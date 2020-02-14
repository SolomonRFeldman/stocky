import React from 'react'
import { render, fireEvent, within } from '@testing-library/react'
import App from '../../App'
import { act } from 'react-dom/test-utils'
import fetchMock from 'fetch-mock'

import { createStore, applyMiddleware, compose } from 'redux'
import manageCurrentUser from '../../reducers/manageCurrentUser'
import { Provider } from 'react-redux';
import thunk from 'redux-thunk'

let navBar

const mockLoginResponse = { id: 1, name: "Test", token: "totesarealtoken" }
fetchMock.post('/signup', mockLoginResponse)

fetchMock.post('/login', mockLoginResponse)

const store = createStore(
  manageCurrentUser,
  applyMiddleware(thunk)
)
const MockReduxedApp = () => {
  return(
    <Provider store={store}>
      <App />
    </Provider>
  )
}

afterEach(() => {
  store.dispatch({ type: 'REMOVE_CURRENT_USER' })
})

it('renders the web app name', async() => {
  await act( async() => navBar = render(<MockReduxedApp />).getByLabelText('Navbar'))
  expect(navBar).toHaveTextContent('STOCKY')  
})

it('has a sign up button that opens a sign up modal/form', async() => {
  await act(async() => navBar = render(<MockReduxedApp />).getByLabelText('Navbar'))
  const signUpButton = within(navBar).getByLabelText('Sign Up')
  await act(async() => fireEvent.click(signUpButton))
  expect(within(document).getByLabelText('Sign Up Modal')).toBeInTheDocument()
})

it('sends the correct data to the server when the signup form is filled and submitted', async() => {
  await act(async() => navBar = render(<MockReduxedApp />).getByLabelText('Navbar'))
  const signUpButton = within(navBar).getByLabelText('Sign Up')
  await act(async() => fireEvent.click(signUpButton))
  const signUpForm = within(document).getByLabelText('Sign Up Modal')
  
  await act(async() => fireEvent.change(within(signUpForm).getByLabelText('Name'), { target: { value: 'Test' } }))
  await act(async() => fireEvent.change(within(signUpForm).getByLabelText('Email'), { target: { value: 'Test@123.com' } }))
  await act(async() => fireEvent.change(within(signUpForm).getByLabelText('Password'), { target: { value: '123' } }))
  await act(async() => fireEvent.change(within(signUpForm).getByLabelText('Password Confirmation'), { target: { value: '123' } }))
  await act(async() => fireEvent.click(within(signUpForm).getByLabelText('Submit Sign Up')))

  const expectedCall = { name: "Test", email: "Test@123.com", password: "123", password_confirmation: "123" }
  const params = JSON.parse(fetchMock.lastOptions().body).user
  expect(params.name).toBe(expectedCall.name)
  expect(params.email).toBe(expectedCall.email)
  expect(params.password).toBe(expectedCall.password)
  expect(params.password_confirmation).toBe(expectedCall.password_confirmation)
})

it('logs the user in, displays their name in the banner with a logout button, and closes the modal when they sign up', async() => {
  await act(async() => navBar = render(<MockReduxedApp />).getByLabelText('Navbar'))
  const signUpButton = within(navBar).getByLabelText('Sign Up')
  await act(async() => fireEvent.click(signUpButton))
  const signUpForm = within(document).getByLabelText('Sign Up Modal')
  
  await act(async() => fireEvent.change(within(signUpForm).getByLabelText('Name'), { target: { value: 'Test' } }))
  await act(async() => fireEvent.change(within(signUpForm).getByLabelText('Email'), { target: { value: 'Test@123.com' } }))
  await act(async() => fireEvent.change(within(signUpForm).getByLabelText('Password'), { target: { value: '123' } }))
  await act(async() => fireEvent.change(within(signUpForm).getByLabelText('Password Confirmation'), { target: { value: '123' } }))
  await act(async() => fireEvent.click(within(signUpForm).getByLabelText('Submit Sign Up')))

  expect(navBar).toHaveTextContent('Test')
  expect(within(navBar).getByLabelText('Log Out')).toBeInTheDocument()
  expect(signUpForm).not.toBeInTheDocument()
})

it('has a log in button that opens a log in modal/form', async() => {
  await act(async() => navBar = render(<MockReduxedApp />).getByLabelText('Navbar'))
  const logInButton = within(navBar).getByLabelText('Log In')
  await act(async() => fireEvent.click(logInButton))
  expect(within(document).getByLabelText('Log In Form')).toBeInTheDocument()
})

it('sends the correct data to the server when the log in form is filled and submitted', async() => {
  await act(async() => navBar = render(<MockReduxedApp />).getByLabelText('Navbar'))
  const logInButton = within(navBar).getByLabelText('Log In')
  await act(async() => fireEvent.click(logInButton))
  const logInForm = within(document).getByLabelText('Log In Form')
  
  await act(async() => fireEvent.change(within(logInForm).getByLabelText('Email'), { target: { value: 'Test@123.com' } }))
  await act(async() => fireEvent.change(within(logInForm).getByLabelText('Password'), { target: { value: '123' } }))
  await act(async() => fireEvent.click(within(logInForm).getByLabelText('Submit Log In')))

  const expectedCall = { email: "Test@123.com", password: "123" }
  const params = JSON.parse(fetchMock.lastOptions().body).user
  expect(params.email).toBe(expectedCall.email)
  expect(params.password).toBe(expectedCall.password)
})

it('logs the user in, displays their name in the banner with a Log In button, and closes the modal when they sign up', async() => {
  await act(async() => navBar = render(<MockReduxedApp />).getByLabelText('Navbar'))
  const logInButton = within(navBar).getByLabelText('Log In')
  await act(async() => fireEvent.click(logInButton))
  const logInForm = within(document).getByLabelText('Log In Form')
  
  await act(async() => fireEvent.change(within(logInForm).getByLabelText('Email'), { target: { value: 'Test@123.com' } }))
  await act(async() => fireEvent.change(within(logInForm).getByLabelText('Password'), { target: { value: '123' } }))
  await act(async() => fireEvent.click(within(logInForm).getByLabelText('Submit Log In')))

  expect(navBar).toHaveTextContent('Test')
  expect(within(navBar).getByLabelText('Log Out')).toBeInTheDocument()
  expect(logInForm).not.toBeInTheDocument()
})