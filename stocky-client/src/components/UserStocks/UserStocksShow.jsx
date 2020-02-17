import React from 'react'
import './UserStocksShow.css'
import { ListGroup } from 'react-bootstrap'
import UserStockShow from './UserStockShow'

export default function UserStocksShow({userStocks}) {
  return(
    <ListGroup className='user-stocks-show'>
      {userStocks.map(userStock => <UserStockShow key={userStock.id} userStock={userStock} />)}
    </ListGroup>
  )
}