import React, { Component } from 'react';
// eslint-disable-next-line
import { Router, browserHistory, Route, Link } from 'react-router';
// eslint-disable-next-line
import { connect } from 'react-redux';
// eslint-disable-next-line
import { Button, Navbar, Nav, NavItem, NavDropdown, MenuItem, Table, ListGroup, ListGroupItem, PageHeader, Panel, PanelGroup, Glyphicon, ButtonGroup, FormGroup, FormControl, ControlLabel, HelpBlock, ButtonToolbar, ToggleButton, ToggleButtonGroup, Checkbox, Radio } from 'react-bootstrap';
// eslint-disable-next-line
import {Menu} from './parts/Menu'
// eslint-disable-next-line
import {contract,serverWallet,provider,newWallet,sendInfura} from './myWeb3All.js'
// eslint-disable-next-line
import FieldGroup from './parts/FieldGroup'
// eslint-disable-next-line
import MyLargeModal from './parts/Modal'
// eslint-disable-next-line
import {terms} from './helpers/terms'
// eslint-disable-next-line
import Web3 from 'web3'
/*
Радио для выбора типа кошеля должно быть выбрано изначально
Добавить в контракт функции администрирования
Добавить в контракт амоунт
Добавить предупреждения о том, что форма заполнена неверно
*/

export class Order extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
    this.changeName = this.changeName.bind(this);
    this.changeWallet = this.changeWallet.bind(this);
    this.changeEmail = this.changeEmail.bind(this);
    this.changeEthAmount = this.changeEthAmount.bind(this);
    // this.changeWalletType = this.changeWalletType.bind(this);
    this.showHideModal = this.showHideModal.bind(this);
    this.changeWalletTypeEth = this.changeWalletTypeEth.bind(this);
    this.changeWalletTypeBtc = this.changeWalletTypeBtc.bind(this);
    this.agreeTerms = this.agreeTerms.bind(this);
    this.state = {
      name: '',
      wallet: '',
      privateKey: '',
      email: '',
      walletType: 'ETH',
      ethAmount: 1000,
      nameForm: false,
      showModal: false,
      agreedTerms: false,
      validationStateName: null,
      validationStateEmail: null,
      validationStateWallet: null,
    };
  }

  componentWillMount() {
    var myWeb3 = new Web3(window.web3.currentProvider);
    myWeb3.eth.getAccounts().then(accounts => {
        console.log(accounts);
    })
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

  changeEmail(event) {
    this.setState({email: event.target.value});
  }

  changeEthAmount(event) {
    this.setState({ethAmount: Number(event.target.value)});
  }

  changeWalletTypeEth(e) {
    this.setState({walletType: 'ETH'});
  }
  changeWalletTypeBtc(e) {
    this.setState({walletType: 'BTC'});
  }

  agreeTerms(event) {
    //console.log(!this.state.agreedTerms);
    this.setState({agreedTerms: !this.state.agreedTerms});
  }

  showHideModal() {
    this.setState({ showModal: !this.state.showModal });
  }

  // получение списка типов печати
  getOrderTypes() {
    //
  }

  // отправить заказ на печать
  submit() {
    //contractFunction = myContract.methods.addOrder(name, email, wallet, walletType, amount)
    //const functionAbi = contractFunction.encodeABI()
  }

  ////
  render() {
    return (
      <div className="App-body">
        <Menu/>


        <Panel>
        <Panel.Body>

          <PageHeader>
            <small>Заказ на печать</small>
          </PageHeader>


          <FieldGroup validationState={this.state.validationStateName}
            id="formControlsText"
            type="text"
            label="Имя"
            placeholder="Ваше имя или Компания"
            value={this.state.name}
            ref={(input)=>{this.nameInput = input}}
            onChange={this.changeName}
          />
        
          <FieldGroup validationState={this.state.validationStateEmail}
            id="formControlsText"
            type="text"
            label="Электронная почта"
            placeholder="email@example.com"
            value={this.state.email}
            ref={(input)=>{this.emailInput = input}}
            onChange={this.changeEmail}
          />


          <FormGroup controlId="formControlsSelect">
            <ControlLabel>Тип печати</ControlLabel>
            <FormControl componentClass="select" placeholder="select">
              <option value="newspaper">Газета</option>
              <option value="magazine">Журнал</option>
              <option value="joghurt">Йогурт</option>
            </FormControl>
          </FormGroup>

          <FieldGroup validationState={this.state.validationStateEmail}
            id="formControlsText"
            type="text"
            label="Площадь страницы, см2"
            placeholder="10"
            value={this.state.email}
            ref={(input)=>{this.emailInput = input}}
            onChange={this.changeEmail}
          />

          <FieldGroup validationState={this.state.validationStateEmail}
            id="formControlsText"
            type="text"
            label="Количество страниц"
            placeholder="10"
            value={this.state.email}
            ref={(input)=>{this.emailInput = input}}
            onChange={this.changeEmail}
          />

          <FieldGroup validationState={this.state.validationStateWallet}
            id="formControlsText"
            type="text"
            label="Тираж"
            placeholder="1000"
            value={this.state.ethAmount}
            ref={(input)=>{this.ethAmountInput = input}}
            onChange={this.changeEthAmount}
          />


          <Button bsSize="" bsStyle="primary"
              ref={(input)=>{this.button = input}}
              onClick={this.submit.bind(this)}>
              Отправить
          </Button>
          <br/>
          <br/>
          <br/>

          <MyLargeModal
            show={this.state.showModal}
            onHide={this.showHideModal}
          ></MyLargeModal>

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
)(Order)





/*



<FieldGroup validationState={this.state.validationStateWallet}
  id="formControlsText"
  type="text"
  label="Wallet address"
  placeholder="0xfe0D3969f978b7a8292b94C66BEF73d5B3490243"
  value={this.state.wallet}
  ref={(input)=>{this.walletInput = input}}
  onChange={this.changeWallet}
/>



          <FormGroup>
            <Radio name="radioGroup" inline
              ref={(input)=>{this.walletTypeInput = input}}
              onClick={this.changeWalletTypeEth}
            >
              ETH wallet
            </Radio>{' '}
            <Radio name="radioGroup" inline
              ref={(input)=>{this.walletTypeInput = input}}
              onClick={this.changeWalletTypeBtc}
            >
              BTC wallet
            </Radio>{' '}
          </FormGroup>





                    <Checkbox inline
                       validationState={null}
                       onChange={this.agreeTerms}
                    >
                      I agree with Terms and Conditions
                    </Checkbox>
                    <Button bsSize="" bsStyle="link"
                        onClick={this.showHideModal}>
                        (Read Terms)
                    </Button>
                    <br/>
                    <br/>

*/
