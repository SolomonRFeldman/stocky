import React from 'react'
import './UserStockShow.css'
import { ListGroupItem } from 'react-bootstrap'

export default function UserStockShow({ userStock }) {

  const stockValueHighlight = () => {
    if(userStock.latestPrice > userStock.open) {
      return '-green'
    } else if(userStock.latestPrice < userStock.open) {
      return '-red'
    } else {
      return ''
    }
  }

  return(
    <ListGroupItem className='user-stock-show'>
      {userStock.symbol} - {userStock.shares} Shares
      <span className={`float-right value-span${stockValueHighlight()}`}>
        ${(userStock.latestPrice * userStock.shares).toFixed(2)}
      </span>
    </ListGroupItem>
  )
}