import React from 'react'
import { ListGroupItem } from 'react-bootstrap'

export default function UserStockShow({ userStockHistory }) {

  const transactionType = () => userStockHistory.shares < 0 ? "SELL" : "BUY"

  return(
    <ListGroupItem>
      {transactionType()} ({userStockHistory.symbol})
      <span className='float-right'>{Math.abs(userStockHistory.shares)} @ ${Math.abs(userStockHistory.price)}</span>
    </ListGroupItem>
  )
}