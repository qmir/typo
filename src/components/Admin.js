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

export class Admin extends Component {
  constructor(props) {
    super(props);
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



  ////
  render() {
    return (
      <div className="App-body">
        <Menu/>


        <Panel>
        <Panel.Body>

          <PageHeader>
            <small>Кабинет управления</small>
          </PageHeader>


          Таблица заказов
          <Table striped bordered condensed hover>
            <thead>
              <tr>
                <th>#</th>
                <th>Имя клиента</th>
                <th>Эл. почта</th>
                <th>Тип печати</th>
                <th>Площадь страницы, см2</th>
                <th>Количество страниц</th>
                <th>Тираж</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>1</td>
                <td>Алексей</td>
                <td>aleks@gmail.com</td>
                <td>Журнал</td>
                <td>20</td>
                <td>40</td>
                <td>100</td>
                <td>
                  <ButtonGroup>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="edit" />
                    </Button>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="trash" />
                    </Button>
                  </ButtonGroup>
                </td>
              </tr>
              <tr>
                <td>2</td>
                <td>ООО "Новая газета"</td>
                <td>gazeta@ya.ru</td>
                <td>Газета</td>
                <td>100</td>
                <td>20</td>
                <td>1000</td>
                <td>
                  <ButtonGroup>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="edit" />
                    </Button>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="trash" />
                    </Button>
                  </ButtonGroup>
                </td>
              </tr>
              <tr>
                <td>3</td>
                <td>Алексей</td>
                <td>aleks@gmail.com</td>
                <td>Упаковка</td>
                <td>12</td>
                <td>1</td>
                <td>10000</td>
                <td>
                  <ButtonGroup>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="edit" />
                    </Button>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="trash" />
                    </Button>
                  </ButtonGroup>
                </td>
              </tr>
            </tbody>
          </Table>

          Очередь печати
          <Table striped bordered condensed hover>
            <thead>
              <tr>
                <th>#</th>
                <th>Статус</th>
                <th>Имя клиента</th>
                <th>Эл. почта</th>
                <th>Тип печати</th>
                <th>Тираж</th>
                <th>Время печати, мин</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>1</td>
                <td>На печати</td>
                <td>Алексей</td>
                <td>aleks@gmail.com</td>
                <td>Журнал</td>
                <td>100</td>
                <td>60</td>
                <td>
                  <ButtonGroup>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="edit" />
                    </Button>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="trash" />
                    </Button>
                  </ButtonGroup>
                </td>
              </tr>
              <tr>
                <td>2</td>
                <td>В очереди</td>
                <td>ООО "Новая газета"</td>
                <td>gazeta@ya.ru</td>
                <td>Газета</td>
                <td>1000</td>
                <td>240</td>
                <td>
                  <ButtonGroup>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="edit" />
                    </Button>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="trash" />
                    </Button>
                  </ButtonGroup>
                </td>
              </tr>
              <tr>
                <td>3</td>
                <td>Отменен</td>
                <td>Алексей</td>
                <td>aleks@gmail.com</td>
                <td>Газета</td>
                <td>100</td>
                <td>15</td>
                <td>
                  <ButtonGroup>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="edit" />
                    </Button>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="trash" />
                    </Button>
                  </ButtonGroup>
                </td>
              </tr>
              <tr>
                <td>Итог</td>
                <td> </td>
                <td> </td>
                <td> </td>
                <td> </td>
                <td> </td>
                <td>315</td>
              </tr>
            </tbody>
          </Table>


          Таблица материалов на складе
          <Table striped bordered condensed hover>
            <thead>
              <tr>
                <th>#</th>
                <th>Название</th>
                <th>Количество</th>
                <th>Ед.изм.</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>1</td>
                <td>Бумага А4</td>
                <td>4000</td>
                <td>шт</td>
                <td>
                  <ButtonGroup>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="edit" />
                    </Button>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="trash" />
                    </Button>
                  </ButtonGroup>
                </td>
              </tr>
              <tr>
                <td>2</td>
                <td>Краска черная</td>
                <td>400</td>
                <td>уп</td>
                <td>
                  <ButtonGroup>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="edit" />
                    </Button>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="trash" />
                    </Button>
                  </ButtonGroup>
                </td>
              </tr>
              <tr>
                <td>3</td>
                <td>Краска синяя</td>
                <td>300</td>
                <td>уп</td>
                <td>
                  <ButtonGroup>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="edit" />
                    </Button>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="trash" />
                    </Button>
                  </ButtonGroup>
                </td>
              </tr>
            </tbody>
          </Table>



          Таблица сотрудников
          <Table striped bordered condensed hover>
            <thead>
              <tr>
                <th>#</th>
                <th>Имя</th>
                <th>Должность</th>
                <th>Кошелек</th>
                <th>Приватный ключ</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>1</td>
                <td>Иван Иванов</td>
                <td>владелец</td>
                <td>0xfe0D3969f978b7a8892b94C66BEF73d8B3490243</td>
                <td>3a1076bf45ab87712ad64ccb3b10217737f7faacbf2872e88fdd9a537d8fe266</td>
                <td>
                  <ButtonGroup>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="edit" />
                    </Button>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="trash" />
                    </Button>
                  </ButtonGroup>
                </td>
              </tr>
              <tr>
                <td>2</td>
                <td>Петр Петров</td>
                <td>менеджер</td>
                <td>0xc2d7dcf95645d330f06175b78989035c7c9061d3f9</td>
                <td>67f458a5fa32647f294ff11346ss4dfefdced9e0d129c061bfa655ec53759a849</td>
                <td>
                  <ButtonGroup>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="edit" />
                    </Button>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="trash" />
                    </Button>
                  </ButtonGroup>
                </td>
              </tr>
              <tr>
                <td>3</td>
                <td>Сергей Сергеев</td>
                <td>кладовщик</td>
                <td>0xdd4eccd74d2d1f7887f50c27aebdb14d99bd7571b6</td>
                <td>b819f1769169beaf7e6dcdb578dad519eccb86cf3139c3707b450caa1383ba</td>
                <td>
                  <ButtonGroup>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="edit" />
                    </Button>
                    <Button bsSize="xsmall">
                      <Glyphicon glyph="trash" />
                    </Button>
                  </ButtonGroup>
                </td>
              </tr>
            </tbody>
          </Table>



        </Panel.Body>
        </Panel>


        <Panel>
        <Panel.Body>
          Добавления сотрудника
          <br/>
          <br/>

          <FieldGroup validationState={this.state.validationStateEmail}
            id="formControlsText"
            type="text"
            label="Имя"
            placeholder="Иван Иванов"
            value={this.state.email}
            ref={(input)=>{this.emailInput = input}}
            onChange={this.changeEmail}
          />

          <FormGroup controlId="formControlsSelect">
            <ControlLabel>Должность</ControlLabel>
            <FormControl componentClass="select" placeholder="select">
              <option value="newspaper">владелец</option>
              <option value="magazine">менеджер</option>
              <option value="joghurt">кладовщик</option>
            </FormControl>
          </FormGroup>

          <FieldGroup validationState={this.state.validationStateEmail}
            id="formControlsText"
            type="text"
            label="Кошелек"
            placeholder="0xfe0D3969f978b7a8892b94C66BEF73d8B3490243"
            value={this.state.email}
            ref={(input)=>{this.emailInput = input}}
            onChange={this.changeEmail}
          />

          <FieldGroup validationState={this.state.validationStateEmail}
            id="formControlsText"
            type="text"
            label="Приватный ключ"
            placeholder="b819f1769169beaf7e6dcdb578dad519eccb86cf3139c3707b450caa1383ba"
            value={this.state.email}
            ref={(input)=>{this.emailInput = input}}
            onChange={this.changeEmail}
          />
          <Button bsSize="" bsStyle=""
              ref={(input)=>{this.button = input}}>
              Создать кошелек
          </Button>
          <br/>
          <Button bsSize="" bsStyle="primary"
              ref={(input)=>{this.button = input}}>
              Добавить
          </Button>


        </Panel.Body>
        </Panel>



        <Panel>
        <Panel.Body>
          Добавление материала на склад
          <br/>
          <br/>

          <FieldGroup validationState={this.state.validationStateEmail}
            id="formControlsText"
            type="text"
            label="Название"
            placeholder="Бумага А4"
            value={this.state.email}
            ref={(input)=>{this.emailInput = input}}
            onChange={this.changeEmail}
          />

          <FieldGroup validationState={this.state.validationStateEmail}
            id="formControlsText"
            type="text"
            label="Количество"
            placeholder="10"
            value={this.state.email}
            ref={(input)=>{this.emailInput = input}}
            onChange={this.changeEmail}
          />



          <FormGroup controlId="formControlsSelect">
            <ControlLabel>Ед. изм.</ControlLabel>
            <FormControl componentClass="select" placeholder="select">
              <option value="newspaper">шт</option>
              <option value="magazine">литр</option>
              <option value="joghurt">уп</option>
            </FormControl>
          </FormGroup>

          <Button bsSize="" bsStyle="primary"
              ref={(input)=>{this.button = input}}>
              Добавить
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
)(Admin)





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
