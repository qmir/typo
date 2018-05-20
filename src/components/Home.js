import React, { Component } from 'react';
// eslint-disable-next-line
import { Router, browserHistory, Route, Link } from 'react-router';
// eslint-disable-next-line
import { connect } from 'react-redux';
// eslint-disable-next-line
import { Button, Navbar, Nav, NavItem, NavDropdown, MenuItem, Table, ListGroup, ListGroupItem, PageHeader, Panel, PanelGroup, Glyphicon, ButtonGroup, FormGroup, FormControl, ControlLabel, HelpBlock, ButtonToolbar, ToggleButton, ToggleButtonGroup } from 'react-bootstrap';
import {Menu} from './parts/Menu'
// eslint-disable-next-line
import {contract,serverWallet,provider,newWallet,sendInfura} from './myWeb3All.js'
// eslint-disable-next-line
import FieldGroup from './parts/FieldGroup'



export class Home extends Component {
  constructor(props) {
    super(props);
    this.state = {
        name: '',
        wallet: '',
        privateKey: '',
        nameForm: false,
    };
    this.handleChange = this.handleChange.bind(this);
    this.changeName = this.changeName.bind(this);
    this.changeWallet = this.changeWallet.bind(this);
    this.changePrivateKey = this.changePrivateKey.bind(this);
    this.add = this.add.bind(this);
  }

  handleChange(event,arg) {
    this.setState({value: event.target.value});
  }

  changeName(event) {
    this.setState({name: event.target.value});
  }

  changeWallet(event) {
    this.setState({wallet: event.target.value});
  }

  changePrivateKey(event) {
    this.setState({privateKey: event.target.value});
  }

  createWallet() {
    var wallet = newWallet();
    this.setState({
      nameForm: true,
      wallet:wallet.address,
      privateKey:wallet.privateKey
    })
  }

  signIn() {

  }

  add() {
      //this.state.nameInput.props.children = 'asdf'
      //this.state.walletInput.value='asdsdv';
      console.log(this.walletInput);
  }

  ////
  render() {
    return (
      <div className="App-body">
        <Menu/>


        <Panel>
        <Panel.Body>

          <PageHeader>
            Typo <small>Типография на основе умных контактов.</small>
          </PageHeader>

          Главная страница с описанием проекта

        </Panel.Body>
        </Panel>


      </div>
    );
  }
}


export default connect(
  state => ({
    name: state.name,
    wallet: state.wallet,
    privateKey: state.privateKey,
  }),
  dispatch => ({})
)(Home)
