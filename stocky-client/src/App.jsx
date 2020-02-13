import React from 'react';
import 'bootswatch/dist/journal/bootstrap.min.css';

import { createStore, applyMiddleware, compose } from 'redux'
import { Provider } from 'react-redux';
import manageCurrentUser from './reducers/manageCurrentUser';
import thunk from 'redux-thunk'

import NavBar from './components/NavBar/NavBar';

const store = createStore(
  manageCurrentUser,
  compose(
    window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__(),
    applyMiddleware(thunk)
  )
)

function App() {
  return (
    <Provider store={store}>
      <div className="App">
        <header>
          <NavBar />
        </header>
      </div>
    </Provider>
  );
}

export default App;
