import { routerReducer } from 'react-router-redux';
import { combineReducers } from 'redux';


import userReducer from './user';


export const allReducers = combineReducers({
  users: userReducer,
  routing: routerReducer,
});
