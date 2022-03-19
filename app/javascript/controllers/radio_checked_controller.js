
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["option"]

  connect() {
  }

  selectRadioOption(e){
    this.optionTargets.forEach(option => {
      console.log(option);
      option.classList.remove("radio-checked");
    });
    e.currentTarget.classList.add("radio-checked");
  }
}
