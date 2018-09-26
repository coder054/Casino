import React, { Component } from "react";
import { inject, observer } from "mobx-react";

import { Radio, InputNumber, Divider, Button } from "antd";
import casino from "../ethereum/casino";
import web3 from "../ethereum/web3";

const RadioGroup = Radio.Group;

class Home extends Component {
  state = {
    money: "",
    number: "",
    loading: false,
    betInfos: {
      isAlreadyBet: undefined,
      money: 0,
      number: 0
    }
  };

  async componentWillMount() {
    let minimumMoney = await casino.methods.minimumMoney().call();
    let totalBets = await casino.methods.totalBets().call();
    let totalMoney = await casino.methods.totalMoney().call();
    let maxAllowBets = await casino.methods.maxAllowBets().call();
    let lastWinnerNumer = await casino.methods.lastWinnerNumer().call();
    let accounts = await web3.eth.getAccounts();
    console.log(accounts);

    const getBetInfos = await casino.methods.getBetInfo(accounts[0]).call();

    console.log(getBetInfos);
    var betInfos = { ...this.state.betInfos };
    betInfos.isAlreadyBet = getBetInfos[0];
    betInfos.number = getBetInfos[1];
    betInfos.money = getBetInfos[2];
    this.setState({ betInfos });

    this.setState({
      minimumMoney,
      totalBets,
      totalMoney,
      maxAllowBets,
      lastWinnerNumer
    });
  }

  renderBet() {
    if (this.state.betInfos.isAlreadyBet === undefined) {
      return "Loading";
    } else if (this.state.betInfos.isAlreadyBet === false) {
      return (
        <div>
          <h3>Vote for the next number</h3>
          <div>
            <h4>
              How much <strong>ETHER</strong> do you want to bet
            </h4>
            <InputNumber
              addonAfter=".com"
              defaultValue={this.state.number}
              onChange={value => {
                this.setState({
                  money: value
                });
              }}
            />
            <div>
              <RadioGroup
                onChange={e => {
                  this.setState({ number: e.target.value });
                }}
                value={this.state.number}
              >
                <Radio value={1}>1</Radio>
                <Radio value={2}>2</Radio>
                <Radio value={3}>3</Radio>
                <Radio value={4}>4</Radio>
                <Radio value={5}>5</Radio>
                <Radio value={6}>6</Radio>
                <Radio value={7}>7</Radio>
                <Radio value={8}>8</Radio>
                <Radio value={9}>9</Radio>
                <Radio value={10}>10</Radio>
              </RadioGroup>
            </div>

            <div>
              <Button
                type="primary"
                loading={this.state.loading}
                onClick={this.onSubmit}
              >
                Bet!
              </Button>
            </div>
          </div>
        </div>
      );
    } else {
      return (
        <div>
          <h4>
            {" "}
            You chosed the number {this.state.betInfos.number}
            with {web3.utils.fromWei(this.state.betInfos.money, "ether")} ether
          </h4>
        </div>
      );
    }
  }

  onSubmit = async e => {
    if (!this.state.number) {
      alert("You must chose a number!");
      return;
    } else if (this.state.money <= 0) {
      alert("The money must be a positive number!");
      return;
    }
    this.setState({ loading: true });
    const accounts = await web3.eth.getAccounts();
    console.log(accounts[0]);
    try {
      await casino.methods.chooseNumber(this.state.number.toString()).send({
        from: accounts[0],
        value: web3.utils.toWei(this.state.money.toString(), "ether"),
        gas: "1000000"
      });
    } catch (err) {
      console.log(err);
    }
    this.setState({ loading: false });
    window.location.reload();
  };

  render() {
    return (
      <div className="HomeRoot">
        <h2> Bet for your bet number and win huge amount of Ether </h2>
        <h4>Number of bet: {this.state.totalBets} </h4>
        <h4>Last number winner {this.state.lastWinnerNumer} </h4>
        <h4>
          Total ether bet:
          {this.state.totalMoney ? (
            <span> {web3.utils.fromWei(this.state.totalMoney, "ether")} </span>
          ) : (
            "Loading"
          )}
        </h4>
        <h4>minimum bet {this.state.minimumMoney} (wei)</h4>
        <h4>max amount of bets {this.state.maxAllowBets} </h4>
        <Divider />
        {this.renderBet()}
      </div>
    );
  }
}

export default Home;
