import React, { useState, useEffect } from 'react'
import './UserStocks.css'
import { CardGroup, Card } from 'react-bootstrap'
import UserStockForm from './UserStockForm'
import { getRequest } from '../../apiRequests'
import { useSelector } from 'react-redux'
import { BrowserRouter as Router, Route } from 'react-router-dom';
import UserStocksShow from './UserStocksShow'

export default function UserStocks(props) {
  const currentUser = useSelector(state => state.currentUser)
  const [user, setUser] = useState({balance: 0, user_stocks: []})
  
  useEffect(() =>{
    getRequest(`/users/${currentUser.id}`).then(fetchedUser => setUser(fetchedUser))
  }, [])

  const userStocksShow = () => <UserStocksShow userStocks={user.user_stocks} />

  return(
    <CardGroup className='mx-auto mt-4 user-stocks'>
      <Card>
        <Router>
          <Route exact path='/' component={userStocksShow} />
        </Router>
      </Card>
      <Card>
        <Card.Body>
          <UserStockForm user={user} setUser={setUser} />
        </Card.Body>
      </Card>
    </CardGroup>
  )
}