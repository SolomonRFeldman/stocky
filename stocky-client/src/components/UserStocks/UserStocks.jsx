import React, { useState, useEffect } from 'react'
import './UserStocks.css'
import { CardGroup, Card } from 'react-bootstrap'
import UserStockForm from './UserStockForm'
import { getRequest } from '../../apiRequests'
import { useSelector } from 'react-redux'
import { BrowserRouter as Router, Route } from 'react-router-dom';
import UserStocksShow from './UserStocksShow'
import UserStockHistories from './UserStockHistories'

export default function UserStocks(props) {
  const currentUser = useSelector(state => state.currentUser)
  const [user, setUser] = useState({balance: 0, user_stocks: [], user_stock_histories: []})
  
  useEffect(() =>{
    getRequest(`/users/${currentUser.id}`).then(fetchedUser => setUser(fetchedUser))
  }, [])

  const userStocksShow = () => <UserStocksShow userStocks={user.user_stocks} />
  const userStockHistories = () => <UserStockHistories userStockHistories={user.user_stock_histories} />
console.log(user)
  return(
    <CardGroup className='mx-auto mt-4 user-stocks'>
      <Card className='show-card'>
        <Router>
          <Route exact path='/' component={userStocksShow} />
          <Route exact path='/transactions' component={userStockHistories} />
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