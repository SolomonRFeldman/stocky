import React from 'react'
import { ListGroup } from 'react-bootstrap'
import UserStockHistory from './UserStockHistory'

export default function UserStockHistories({userStockHistories}) {
  return(
    <ListGroup>
      {userStockHistories.map(userStockHistory => <UserStockHistory key={userStockHistory.id} userStockHistory={userStockHistory} />)}
    </ListGroup>
  )
}