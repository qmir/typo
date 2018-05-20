import React from 'react';
import ReactDOM from 'react-dom';
// eslint-disable-next-line
import { Router, browserHistory, Route, Link } from 'react-router';
// eslint-disable-next-line
import { Provider } from 'react-redux'
// eslint-disable-next-line
import { createStore, combineReducers } from 'redux'
// eslint-disable-next-line
import { routerReducer } from 'react-router-redux';
// eslint-disable-next-line
import { syncHistoryWithStore } from 'react-router-redux';
// eslint-disable-next-line
import registerServiceWorker from './registerServiceWorker';
// eslint-disable-next-line
import { Home, Order, Admin } from './components'
// eslint-disable-next-line
import { allReducers } from './components/reducers';



const initialState = {
  name: 'username1',
  wallet: 'wallet1',
  privateKey: 'privateKey1',
}


// eslint-disable-next-line
function showUser(state=initialState, action) {
  if (action.type === 'SIGN_IN') {
    return {
      name: [action.payload],
      wallet: [action.payload],
      privateKey: [action.payload],
    }
  }
  return state
}

const store = createStore(allReducers);
const history = syncHistoryWithStore(browserHistory, store);
// выполнение функции кажды раз, когда меняется store
store.subscribe(()=>{
  console.log('subscribe', store.getState());
})

//store.dispatch({type: 'SING_IN', payload: 'Data'})


ReactDOM.render(
  <Provider store={store}>
    <Router history={history}>
      <Route path="/" component={Home}/>
      <Route path="/order" component={Order}/>
      <Route path="/admin" component={Admin}/>
    </Router>
  </Provider>,
  document.getElementById('root')
);
registerServiceWorker();
