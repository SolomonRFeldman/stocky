import React from 'react'
import './UserStockForm.css'
import { Card, Form, Button } from 'react-bootstrap'

export default function UserStockForm(props) {

  return(
    <Form className='text-center user-stock-form'>
      <h1 className="display-4 balance">Cash - ${parseInt(props.user.balance).toFixed(2)}</h1>
      <Form.Control className='w-75 my-4 mx-auto' aria-label='Ticker' placeholder='Ticker' />
      <Form.Control className='w-75 my-4 mx-auto' aria-label='Quantity' placeholder='Qty' />
      <Button className='mx-2' variant='success'>Buy</Button>
      <Button className='mx-2'>Sell</Button>
    </Form>
  )
}