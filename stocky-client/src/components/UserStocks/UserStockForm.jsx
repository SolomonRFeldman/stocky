import React, { useState } from 'react'
import './UserStockForm.css'
import { Form, Button } from 'react-bootstrap'
import { postRequest } from '../../apiRequests'

export default function UserStockForm({user, setUser}) {
  const [formData, setFormData] = useState({ symbol: '', shares: '' })
  const handleChange = event => setFormData({ ...formData, [event.target.id]: event.target.value })
  const [errors, setErrors] = useState({})

  const handleSubmit = direction => {
    const sentData = formData
    sentData.shares = direction * parseInt(formData.shares)
    postRequest(`/users/${user.id}/user_stocks`, {user_stock: sentData}).then(response => {
      const userStock = { 
        id: response.id, 
        shares: response.shares, 
        symbol: response.symbol, 
        latestPrice: response.latestPrice, 
        open: response.open 
      }
      const userStockIndex = user.user_stocks.findIndex(stockToRemove => stockToRemove.id === userStock.id)
      if(userStockIndex !== -1) { user.user_stocks.splice(userStockIndex, 1) }
      if(userStock.shares !== 0) { user.user_stocks = [userStock, ...user.user_stocks] }
      setUser({
        ...user,
        balance: response.new_balance,
        user_stocks: user.user_stocks,
        user_stock_histories: [response.user_stock_history, ...user.user_stock_histories]
      })
      setErrors({})
    }).catch(response => {
      response.status === 400 ?
        response.json().then(user_stock => setErrors(user_stock.errors)) :
        setErrors({...errors, server: 'failed to reach server'})
    })
  }

  const balanceError = () => {
    return errors.user && errors.user.balance ?
      <div class='invalid-feedback d-block'>not enough balance</div> :
      null
  }
  return(
    <Form className='text-center user-stock-form'>
      <h1 className="display-4 balance">Cash - ${parseFloat(user.balance).toFixed(2)}</h1>
      {balanceError()}
      <Form.Group>
        <Form.Control 
          id='symbol' 
          className='w-75 my-4 mx-auto' 
          aria-label='Ticker' 
          placeholder='Ticker' 
          onChange={handleChange}
          isInvalid={errors.stock}
        />
        <Form.Control.Feedback type="invalid">{errors.stock}</Form.Control.Feedback>
      </Form.Group>
      <Form.Group>
        <Form.Control 
          id='shares' 
          className='w-75 my-4 mx-auto' 
          aria-label='Quantity' 
          placeholder='Qty'
          type='number'
          min='1'
          onChange={handleChange} 
          isInvalid={errors.shares}
        />
        <Form.Control.Feedback type="invalid">cannot sell more shares then you have</Form.Control.Feedback>
      </Form.Group>
      <Button className='mx-2' variant='success' onClick={() => handleSubmit(1)}>Buy</Button>
      <Button className='mx-2' onClick={() => handleSubmit(-1)}>Sell</Button>
    </Form>
  )
}