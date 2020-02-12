import React from 'react'
import { render, fireEvent, within } from '@testing-library/react'
import App from '../../App'
import { act } from 'react-dom/test-utils'

let navBar

it('renders the web app name', async() => {
  await act( async() => navBar = render(<App />).getByLabelText('Navbar'))
  expect(navBar).toHaveTextContent('STOCKY')  
})

it('has a sign up button that opens a sign up modal/form', async() => {
  await act( async() => navBar = render(<App />).getByLabelText('Navbar'))
  const signUpButton = within(navBar).getByLabelText('Sign Up')
  await act( async() => fireEvent.click(signUpButton))
  expect(within(document).getByLabelText('Sign Up Modal')).toBeInTheDocument()
})