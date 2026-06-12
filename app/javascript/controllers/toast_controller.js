import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    delay: { type: Number, default: 4200 }
  }

  connect() {
    this.timeout = window.setTimeout(() => {
      this.close()
    }, this.delayValue)
  }

  close() {
    window.clearTimeout(this.timeout)

    this.element.classList.add("is-leaving")

    window.setTimeout(() => {
      this.element.remove()
    }, 220)
  }

  disconnect() {
    window.clearTimeout(this.timeout)
  }
}
