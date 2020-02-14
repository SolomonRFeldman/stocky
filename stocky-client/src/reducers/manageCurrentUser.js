export default function manageCurrentUser(
  state = { currentUser: {} },
  action
) {
  switch(action.type) {
    case 'ADD_CURRENT_USER':
      return { ...state, currentUser: { ...action.payload } }
    case 'REMOVE_CURRENT_USER':
      return { ...state, currentUser: {} };
    default:
      return state
  }
}