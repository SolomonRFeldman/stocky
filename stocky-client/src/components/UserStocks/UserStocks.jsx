import React, { useState, useEffect } from 'react'
import './UserStocks.css'
import { CardGroup, Card } from 'react-bootstrap'
import UserStockForm from './UserStockForm'
import { getRequest } from '../../apiRequests'
import { useSelector } from 'react-redux'

export default function UserStocks(props) {
  const currentUser = useSelector(state => state.currentUser)
  const [user, setUser] = useState({balance: 0})
  
  useEffect(() =>{
    getRequest(`/users/${currentUser.id}`).then(fetchedUser => setUser(fetchedUser))
  }, [])

  return(
    <CardGroup className='mx-auto mt-4 user-stocks'>
      <Card>
      </Card>
      <Card>
        <Card.Body>
          <UserStockForm user={user} />
        </Card.Body>
      </Card>
    </CardGroup>
  )
}