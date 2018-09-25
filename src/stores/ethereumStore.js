import { observable, action, computed } from "mobx";
import casino from "../../ethereum/casino.js";

export class ethereumStore {
  @observable casino = casino;
}

export default new ethereumStore();
