import React, { Component } from 'react';
import { Router, browserHistory, Route, Link } from 'react-router';
import { connect } from 'react-redux';
import { Button, Navbar, Nav, NavItem, NavDropdown, MenuItem, Table, ListGroup, ListGroupItem, PageHeader, Panel, PanelGroup, Glyphicon, ButtonGroup, FormGroup, FormControl, ControlLabel, HelpBlock, ButtonToolbar, ToggleButton, ToggleButtonGroup } from 'react-bootstrap';
import {Menu} from './parts/Menu'
import {contract,serverWallet,provider,newWallet,sendInfura} from './myWeb3All.js'
import FieldGroup from './parts/FieldGroup'



export class TokenSale extends Component {
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
            Icareum <small>Сервис по созданию архитектурных визуализаций.</small>
          </PageHeader>


          {this.state.nameForm && <FieldGroup
            id="formControlsText"
            type="text"
            label="Name"
            placeholder="Name or Company"
            value={this.state.name}
            ref={(input)=>{this.nameInput = input}}
            onChange={this.changeName}
          />}
          <FieldGroup
            id="formControlsText"
            type="text"
            label="Wallet"
            placeholder="0xfe0D3969f978b7a8892b94C66BEF73d5B3490243"
            value={this.state.wallet}
            ref={(input)=>{this.walletInput = input}}
            onChange={this.changeWallet}
          />
          <FieldGroup
            id="formControlsText"
            type="text"
            label="Private key"
            placeholder="6e3407502f94382c12311104fb407e7bbc200e1a82aa9baeedb78fad53f64ec1"
            value={this.state.privateKey}
            onChange={this.changePrivateKey}
            help={this.state.nameForm && "Please, save your private key in safe place!"}
          />


          <Button bsSize=""
              href="/work"
              onClick={() => this.signIn()}>
              Sign in
          </Button>
          <br/>
          <Button bsSize=""
              onClick={() => this.createWallet()}>
              Create new wallet
          </Button>
          <br/>
          <Button bsSize=""
              ref={(input)=>{this.button = input}}
              onClick={this.add.bind(this)}>
              Черновик
          </Button>

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
)(TokenSale)
