
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["option"]

  connect() {
    console.log("Hello from our first Stimulus controller")
  }

  selectRadioOption(e){
    console.log(this.optionTargets)
    this.optionTargets.forEach(option => {
      console.log(option);
      option.classList.remove("radio-checked");
    });
    e.currentTarget.classList.add("radio-checked");
  }
}
