import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "selectedSize", "variantId"]

  select(event) {
    const clickedButton = event.currentTarget
    const size = clickedButton.dataset.size
    const variantId = clickedButton.dataset.variantId

    this.buttonTargets.forEach((button) => {
      button.classList.remove("is-selected")
    })

    clickedButton.classList.add("is-selected")

    if (this.hasSelectedSizeTarget) {
      this.selectedSizeTarget.textContent = size
    }

    if (this.hasVariantIdTarget) {
      this.variantIdTarget.value = variantId
    }
  }
}
