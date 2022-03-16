import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

export default class extends Controller {
  static values = { apiKey: String }

  static targets = ["query"]

  connect() {
    console.log(this.queryTarget)
    this.geocoder = new MapboxGeocoder({
      accessToken: this.apiKeyValue,
      types: "country,region,place,locality,neighborhood,address"
    });
    this.geocoder.addTo(this.element)
    this.geocoder.on("result", event => this.#setInputValue(event))
    this.geocoder.on("clear", () => this.#clearInputValue())
  }

  #setInputValue(event) {
    this.queryTarget.value = event.result["place_name"]
    console.log(this.queryTarget.value)
  }

  #clearInputValue() {
    this.queryTarget.value = ""
    console.log(this.queryTarget.value)
  }
}
