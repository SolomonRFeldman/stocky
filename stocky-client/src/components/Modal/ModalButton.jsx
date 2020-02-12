import React, { useState } from 'react'
import Button from 'react-bootstrap/Button';

export default function ModalButton(props) {
  const [showForm, setShowForm] = useState(false)

  const handleFormShow = () => setShowForm(true)
  const handleFormClose = () => setShowForm(false)

  return (
    <React.Fragment>
      <Button 
        className={props.className} 
        aria-label={props['aria-label']} 
        variant={props.variant} 
        onClick={handleFormShow}
      >
        {props.children}
      </Button>
      <props.modal show={showForm} handleClose={handleFormClose} />
    </React.Fragment>
  )
}