import React, { Component } from "react";
import logo from "./logo.svg";
import "./App.css";
import { Route, Switch, withRouter } from "react-router-dom";
import Home from "./components/Home.js";

class App extends Component {
  render() {
    return (
      <div className="App">
        <Switch>
          <Route exact path="/" component={Home} />
        </Switch>
      </div>
    );
  }
}

export default App;
