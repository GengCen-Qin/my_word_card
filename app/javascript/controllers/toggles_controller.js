import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggles"
export default class extends Controller {
  toggle() {
    this.element.parentNode.classList.toggle("active")
  }
}
