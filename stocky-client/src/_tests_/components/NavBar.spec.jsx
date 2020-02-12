import React from 'react'
import { render } from '@testing-library/react'
import App from '../../App'

it('renders the web app name', () => {
  const navBar = render(<App />).getByLabelText('Navbar')
  expect(navBar).toHaveTextContent('STOCKY')  
})