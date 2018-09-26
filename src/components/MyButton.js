import React, { Component } from "react";
import { inject, observer } from "mobx-react";

@inject("UIStore")
@observer
class MyButton extends Component {
  render() {
    const { UIStore } = this.props;
    return (
      <button className={true ? "true" : "false"}>{this.props.content}</button>
    );
  }
}

export default MyButton;
