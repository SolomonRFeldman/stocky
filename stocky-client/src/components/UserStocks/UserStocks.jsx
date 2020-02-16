import React from 'react'
import './UserStocks.css'
import { CardGroup, Card } from 'react-bootstrap'
import UserStockForm from './UserStockForm'

export default function UserStocks(props) {
  return(
    <CardGroup className='mx-auto mt-4 user-stocks'>
      <Card>
      </Card>
      <Card>
        <Card.Body>
          <UserStockForm />
        </Card.Body>
      </Card>
    </CardGroup>
  )
}