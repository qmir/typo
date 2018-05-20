import React, { Component } from 'react';
import { Router, browserHistory, Route, Link } from 'react-router';
import { Button, Navbar, Nav, NavItem, NavDropdown, MenuItem, Table, ListGroup, ListGroupItem, PageHeader, Panel, PanelGroup, Glyphicon, ButtonGroup, FormGroup, FormControl, ControlLabel, HelpBlock, ButtonToolbar, ToggleButton, ToggleButtonGroup } from 'react-bootstrap';
import {Menu} from './parts/Menu'


var data = [
  { level: 0, name: 'Bot', text: 'Asdflkjhlasdf asdkfjas dfalskdjf ' },
  { level: 0, name: 'Bot', text: 'Asdflkjhlasdf asdkfjas dfalskdjf ' },
  { level: 1, name: 'Client', text: 'Asdflkjhlasdf asdkfjas dfalskdjf ' },
  { level: 1, name: 'Client', text: 'Asdflkjhlasdf asdkfjas dfalskdjf ' },
  { level: 1, name: 'Client', text: 'Asdflkjhlasdf asdkfjas dfalskdjf ' },
  { level: 1, name: 'Element 2.1', text: 'Asdflkjhlasdf asdkfjas dfalskdjf ' },
  { level: 1, name: 'Element 2.1', text: 'Asdflkjhlasdf asdkfjas dfalskdjf ' },
  { level: 1, name: 'Element 2.1', text: 'Asdflkjhlasdf asdkfjas dfalskdjf ' },
  { level: 1, name: 'Element 2.1', text: 'Asdflkjhlasdf asdkfjas dfalskdjf ' },
  { level: 2, name: 'Element 2.1', text: 'Asdflkjhlasdf asdkfjas dfalskdjf ' },
]



export class Constructor extends Component {
  constructor(props) {
    super(props);
    this.state = {
      sections: [],
      value: '',
      toggleReduct: false
    };
    this.handleChange = this.handleChange.bind(this);
  }
  // function goes thru all children in the object, and children of children
  getFromObj = (field,d) => {
    var out = [];
  	for(let i = 0; i < d.length; i++){
      var level = d[i]['level'];
      var name = d[i]['name'];
      var text = d[i]['text'];
      // shorten text
      var len = 20 - 2 * level;
      var textShort;
      var a = text.split('');
      if (a.length > len) {
        a.splice(len,a.length-len,'...')
        textShort = a
      }
      // reduct textShort
      if (this.state.toggleReduct) {
        textShort =
        <FormControl componentClass="textarea"
          placeholder="textarea"
          value={this.state['val_'+i]}
        />
      }
      //
      this.setState({['val_'+i]:{text}})
      out.push(
        <Panel eventKey={i} style={{marginLeft: 10 * level}}>
          <Panel.Heading toggle>

            <Panel.Toggle componentClass="a">
              {name}: {textShort}
            </Panel.Toggle>

            <ButtonGroup style={{left: 20}}>
              <Button bsSize="xsmall">
                <Glyphicon glyph="plus" />
              </Button>
              <Button bsSize="xsmall" onClick={this.reduct()}>
                <Glyphicon glyph="pencil" />
              </Button>
              <Button bsSize="xsmall">
                <Glyphicon glyph="trash" />
              </Button>
            </ButtonGroup>

          </Panel.Heading>
          <Panel.Body collapsible>
            <FormControl componentClass="textarea"
              placeholder="textarea"
              value={this.state['val_'+i]}
              onChange={(e) => this.handleChange(e,'val_'+i)}
            />
          </Panel.Body>
        </Panel>
      )
  	}
    this.setState({sections:out})
  }
  // input change
  handleChange(e,n) {
    this.setState({ n: e.target.value });
  }
  //
  reduct() {
    this.setState({toggleReduct:true})
  }
  //
  componentWillMount() {
    this.getFromObj('text',data);
  }
  //
  render() {
    return (
      <div className="App">

        <Menu/>
        <PageHeader>
          Call-Cent <small>Constructor</small>
        </PageHeader>



        <form>
          <FormGroup
            controlId="formBasicText"
          >
            <ControlLabel>Speech</ControlLabel>
            <FormControl
              type="text"
              value={this.state['val_1']}
              placeholder="Enter text"
              onChange={(e) => this.handleChange(e,'val_1')}
            />
          <ButtonToolbar>
            <ToggleButtonGroup type="radio" bsSize="small" name="options" defaultValue={1}>
              <ToggleButton value={1}>1</ToggleButton>
              <ToggleButton value={2}>2</ToggleButton>
              <ToggleButton value={3}>3</ToggleButton>
              <ToggleButton value={4}>4</ToggleButton>
              <ToggleButton value={5}>5</ToggleButton>
              <ToggleButton value={6}>6</ToggleButton>
              <ToggleButton value={7}>7</ToggleButton>
              <ToggleButton value={8}>8</ToggleButton>
              <ToggleButton value={9}>9</ToggleButton>
              <ToggleButton value={0}>0</ToggleButton>
            </ToggleButtonGroup>
          </ButtonToolbar>
          </FormGroup>
        </form>



        <PanelGroup
          id="accordion-controlled-example"
          activeKey={this.state.activeKey}
          onSelect={this.handleSelect}
        >
          {this.state.sections}
        </PanelGroup>


      </div>
    );
  }
}
