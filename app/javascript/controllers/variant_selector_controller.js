import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "selectedSize", "variantId", "cartButton"]

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

  validateBeforeSubmit(event) {
    if (!this.hasVariantIdTarget || this.variantIdTarget.value) return

    event.preventDefault()

    this.showSweetAlert({
      title: "Escolha um tamanho",
      message: "Para adicionar esta peça ao carrinho, selecione um tamanho disponível.",
      buttonText: "Entendi"
    })
  }

  showSweetAlert({ title, message, buttonText }) {
    this.removeExistingAlert()

    const overlay = document.createElement("div")
    overlay.classList.add("app-sweet-alert-overlay")
    overlay.dataset.alertOverlay = "true"

    overlay.innerHTML = `
      <div class="app-sweet-alert" role="dialog" aria-modal="true" aria-labelledby="app-sweet-alert-title">
        <button type="button" class="app-sweet-alert__close" aria-label="Fechar alerta">
          <span></span>
          <span></span>
        </button>

        <div class="app-sweet-alert__icon">
          !
        </div>

        <h2 id="app-sweet-alert-title">${title}</h2>

        <p>${message}</p>

        <button type="button" class="app-sweet-alert__button">
          ${buttonText}
        </button>
      </div>
    `

    document.body.appendChild(overlay)
    document.body.classList.add("app-sweet-alert-open")

    const closeButton = overlay.querySelector(".app-sweet-alert__close")
    const actionButton = overlay.querySelector(".app-sweet-alert__button")

    closeButton.addEventListener("click", () => this.closeSweetAlert(overlay))
    actionButton.addEventListener("click", () => this.closeSweetAlert(overlay))

    overlay.addEventListener("click", (event) => {
      if (event.target === overlay) {
        this.closeSweetAlert(overlay)
      }
    })

    window.setTimeout(() => {
      overlay.classList.add("is-visible")
    }, 10)

    window.setTimeout(() => {
      this.closeSweetAlert(overlay)
    }, 4200)
  }

  closeSweetAlert(overlay) {
    if (!overlay || !document.body.contains(overlay)) return

    overlay.classList.remove("is-visible")

    window.setTimeout(() => {
      overlay.remove()
      document.body.classList.remove("app-sweet-alert-open")
    }, 180)
  }

  removeExistingAlert() {
    const existingOverlay = document.querySelector("[data-alert-overlay='true']")

    if (existingOverlay) {
      existingOverlay.remove()
    }

    document.body.classList.remove("app-sweet-alert-open")
  }
}
