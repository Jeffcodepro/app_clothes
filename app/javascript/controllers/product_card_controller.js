import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String
  }

  connect() {
    this.element.setAttribute("role", "link")
    this.element.setAttribute("tabindex", "0")
  }

  open(event) {
    if (this.shouldIgnoreClick(event)) return

    window.location.href = this.urlValue
  }

  openWithKeyboard(event) {
    if (event.key !== "Enter" && event.key !== " ") return

    event.preventDefault()
    window.location.href = this.urlValue
  }

  shouldIgnoreClick(event) {
    return event.target.closest(
      "a, button, input, select, textarea, [data-no-card-link]"
    )
  }
}
