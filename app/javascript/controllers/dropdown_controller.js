import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  connect() {
      // Find the toggle anchor inside this specific <li>
      const toggleEl = this.element.querySelector('[data-bs-toggle="dropdown"]')
      
      if (toggleEl) {
	  // Get or create the Bootstrap instance safely
	  this.dropdown = bootstrap.Dropdown.getOrCreateInstance(toggleEl)
      }
  }
    
    disconnect() {
	if (this.dropdown) {
	    this.dropdown.dispose()
	}
    }
}
