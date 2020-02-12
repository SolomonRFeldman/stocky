import React from 'react'
import { render } from '@testing-library/react'
import App from '../../App'
import { act } from 'react-dom/test-utils'

let navBar

it('renders the web app name', async() => {
  await act( async() => navBar = render(<App />).getByLabelText('Navbar'))
  expect(navBar).toHaveTextContent('STOCKY')  
})