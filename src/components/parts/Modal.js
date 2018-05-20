import React from 'react';
import { Modal, Button } from 'react-bootstrap';
import {terms} from '../helpers/terms'





export default class MyLargeModal extends React.Component {
  render() {
    return (
      <Modal
        {...this.props}
        bsSize="large"
        aria-labelledby="contained-modal-title-lg"
      >
        <Modal.Header closeButton>
          <Modal.Title id="contained-modal-title-lg">Terms and Conditions</Modal.Title>
        </Modal.Header>
        <Modal.Body>

          {terms}

        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this.props.onHide}>Close</Button>
        </Modal.Footer>
      </Modal>
    );
  }
}
