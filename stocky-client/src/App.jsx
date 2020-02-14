import React, { useEffect } from 'react';
import 'bootswatch/dist/journal/bootstrap.min.css';
import NavBar from './components/NavBar/NavBar';
import { useDispatch } from 'react-redux';
import { postRequest } from './apiRequests';

export default function App() {
  const dispatch = useDispatch()
  useEffect(() => {
    const addCurrentUser = payload => dispatch({ type: 'ADD_CURRENT_USER', payload})
    if(localStorage.token) {
      postRequest('/login').then(user => {
        localStorage.token = user.token
        addCurrentUser({ id: user.id, name: user.name })
      })
    }
  }, [])

  return (
    <div className="App">
      <header>
        <NavBar />
      </header>
    </div>
  );
}
