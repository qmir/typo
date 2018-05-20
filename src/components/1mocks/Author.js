import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Router, browserHistory, Route, Link } from 'react-router';
import { Button, Navbar, Nav, NavItem, NavDropdown, MenuItem, Table, ListGroup, ListGroupItem, PageHeader, Panel, PanelGroup, Glyphicon, ButtonGroup, FormGroup, FormControl, ControlLabel, HelpBlock, ButtonToolbar, ToggleButton, ToggleButtonGroup, Label } from 'react-bootstrap';
import {Menu} from './parts/Menu'
import { contract, serverWallet, provider, newWallet, sendInfura } from './myWeb3All.js'
import FieldGroup from './parts/FieldGroup'




export class Author extends Component {
  constructor(props) {
    super(props);
    this.state = {
    };
    //this.parse = this.parse.bind(this);
  }


  get = () => {
    console.log('wallet',this.props.wallet);
    //console.log(serverWallet);
  }


  //
  render() {
    return (
      <div className="App-body">
        <Menu/>
        <PageHeader>
          Convnet Marketplace <small>Hi, {this.state.name}</small>
        </PageHeader>

        <Panel>
          <Button bsStyle="primary" bsSize=""
              onClick={() => this.get()}>
            Черновик
          </Button>

        </Panel>


        <Panel>
        <FormGroup>
            <Panel.Body><h4>Загрузить модель в ипфс и блокчейн</h4></Panel.Body>
            <FormControl
                id="fileUpload"
                type="file"
                accept=".json"
                onChange={this.addFile}
                style={{ /*display: "none"*/ }}
            />
        </FormGroup>
        </Panel>

        <Panel>
        <Panel.Body><h4>Управление</h4></Panel.Body>
        <ButtonGroup>
          <Button bsStyle="primary" bsSize=""
              onClick={() => this.buyModel('','_modelName')}>
            Получить модель из блокчейна (юзер)
          </Button>
          <Button bsStyle="primary" bsSize=""
              onClick={() => this.downloadFile()}>
            Скачать модель
          </Button>
          <Button bsStyle="primary" bsSize=""
              onClick={() => this.getJsonAsync('mynet.json')}>
            Запустить модель
          </Button>
          <Button bsStyle="primary" bsSize=""
              onClick={() => this.getJsonAsync('mynet.json')}>
            Удалить модель
          </Button>
          <Button bsStyle="primary" bsSize=""
              onClick={newWallet}>
            Создать новый кошелек
          </Button>
          <Button bsStyle="primary" bsSize=""
              onClick={sendInfura}>
            Черновик
          </Button>
        </ButtonGroup>
        <br/>
        <br/>
        </Panel>

        <Panel>
          <Panel.Body><h4>Данные о модели</h4></Panel.Body>
          <Panel.Body>Количество нейронных слоев: {this.state.layers}</Panel.Body>
          <Panel.Body>Форма входных данных (текст, массив, изображение):</Panel.Body>
          <Panel.Body>{this.state.formInp}</Panel.Body>
          <Panel.Body>Форма выходных данных (текст, изображение):</Panel.Body>
          <Panel.Body>{this.state.formOutp}</Panel.Body>
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
)(Author)


/*



<ControlLabel htmlFor="fileUpload" style={{ cursor: "pointer" }}>
    <h4>Загрузить модель в ипфс и блокчейн</h4>
</ControlLabel>




  // Парсинг сайта
  parse = (q) => {
      var request = new XMLHttpRequest();
      request.open("GET", "http://gateway.ipfs.io/ipfs/"+q, true);
      request.onreadystatechange = () => {
          var jsontext = request.responseText;
          console.log(1);
          var j = '['+jsontext+']'
          var js = JSON.parse(j)
          //console.log(js[0].layers);
          this.setState({layers:1})
      }
      request.send();
  }




  */
