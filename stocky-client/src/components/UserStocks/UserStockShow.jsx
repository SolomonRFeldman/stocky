import React from 'react'
import { ListGroupItem } from 'react-bootstrap'

export default function UserStockShow({ userStock }) {
  return(
    <ListGroupItem>
      {userStock.symbol} - {userStock.shares} Shares
      <span className='float-right'>${(userStock.latestPrice * userStock.shares).toFixed(2)}</span>
    </ListGroupItem>
  )
}