import React from 'react'
import UserStocks from '../../components/UserStocks/UserStocks'
import manageCurrentUser from '../../reducers/manageCurrentUser'
import { createStore, applyMiddleware } from 'redux'
import { Provider } from 'react-redux'
import { act, render } from '@testing-library/react'
import fetchMock from 'fetch-mock'
import thunk from 'redux-thunk'

let userStocks

fetchMock.post('/user/0/user_stock', {})

const store = createStore(
  manageCurrentUser,
  applyMiddleware(thunk)
)
const ReduxedUserStocks = () => {
  return(
    <Provider store={store}>
      <UserStocks />
    </Provider>
  )
}

beforeAll(() => {
  store.dispatch({ type: 'ADD_CURRENT_USER', payload: { id: 0, name: 'Test' } })
})

it('has a form for sending the server a buy stock request', async() => {
  await act(async() => userStocks = render(<ReduxedUserStocks />))

  const userStockForm = userStocks.getByLabelText('Stock Trading Form')
  await act(async() => fireEvent.change(within(userStockForm).getByLabelText('Ticker'), { target: { value: 'AAPL' } }))
  await act(async() => fireEvent.change(within(userStockForm).getByLabelText('Quantity'), { target: { value: '2' } }))
  await act(async() => fireEvent.click(within(userStockForm).getByLabelText('Buy')))

  const params = JSON.parse(fetchMock.lastOptions().body).user
  expect(params.symbol).toEq('AAPL')
  expect(params.shares).toEq('2')
})

it('has a form for sending the server a sell stock request', async() => {
  await act(async() => userStocks = render(<ReduxedUserStocks />))

  const userStockForm = userStocks.getByLabelText('Stock Trading Form')
  await act(async() => fireEvent.change(within(userStockForm).getByLabelText('Ticker'), { target: { value: 'AAPL' } }))
  await act(async() => fireEvent.change(within(userStockForm).getByLabelText('Quantity'), { target: { value: '2' } }))
  await act(async() => fireEvent.click(within(userStockForm).getByLabelText('Sell')))

  const params = JSON.parse(fetchMock.lastOptions().body).user
  expect(params.symbol).toEq('AAPL')
  expect(params.shares).toEq('-2')
})