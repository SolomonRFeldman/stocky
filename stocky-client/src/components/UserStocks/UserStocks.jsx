import React, { useState, useEffect } from 'react'
import './UserStocks.css'
import { CardGroup, Card } from 'react-bootstrap'
import UserStockForm from './UserStockForm'
import { getRequest } from '../../apiRequests'
import { useSelector } from 'react-redux'
import { Route } from 'react-router-dom';
import UserStocksShow from './UserStocksShow'
import UserStockHistories from './UserStockHistories'

export default function UserStocks(props) {
  const currentUser = useSelector(state => state.currentUser)
  const [user, setUser] = useState({balance: 0, user_stocks: [], user_stock_histories: []})
  
  useEffect(() =>{
    getRequest(`/users/${currentUser.id}`).then(fetchedUser => setUser(fetchedUser))
  }, [currentUser.id])

  const userStocksShow = () => <UserStocksShow userStocks={user.user_stocks} />
  const userStockHistories = () => <UserStockHistories userStockHistories={user.user_stock_histories} />

  return(
    <CardGroup className='mx-auto mt-4 user-stocks'>
      <Card className='show-card'>
        <Route exact path='/' component={userStocksShow} />
        <Route exact path='/transactions' component={userStockHistories} />
      </Card>
      <Card>
        <Card.Body>
          <UserStockForm user={user} setUser={setUser} />
        </Card.Body>
      </Card>
    </CardGroup>
  )
}