import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "variantId", "sizeSelect", "colorSelect", "quantityInput"]
  static values = {
    variants: Array
  }

  connect() {
    this.updateColorOptions()
    this.selectMatchingVariant()
    this.updateQuantityLimit()
  }

  changeSize() {
    this.updateColorOptions()
    this.selectMatchingVariant()
    this.updateQuantityLimit()
    this.submitForm()
  }

  changeColor() {
    this.selectMatchingVariant()
    this.updateQuantityLimit()
    this.submitForm()
  }

  changeQuantity() {
    const variant = this.selectedVariant()

    if (!variant) {
      this.showSweetAlert({
        title: "Opção indisponível",
        message: "Escolha uma combinação de tamanho e cor disponível.",
        buttonText: "Entendi"
      })

      return
    }

    let quantity = parseInt(this.quantityInputTarget.value, 10)

    if (Number.isNaN(quantity) || quantity < 1) {
      quantity = 1
      this.quantityInputTarget.value = quantity
    }

    if (quantity > variant.stock) {
      this.quantityInputTarget.value = variant.stock

      this.showSweetAlert({
        title: "Quantidade indisponível",
        message: `Temos ${variant.stock} unidade${variant.stock === 1 ? "" : "s"} disponível${variant.stock === 1 ? "" : "is"} para essa combinação de tamanho e cor.`,
        buttonText: "Entendi",
        onClose: () => this.submitForm()
      })

      return
    }

    this.submitForm()
  }

  updateColorOptions() {
    if (!this.hasColorSelectTarget) return

    const selectedSize = this.sizeSelectTarget.value
    const variantsForSize = this.variantsValue.filter((variant) => {
      return String(variant.size) === String(selectedSize)
    })

    const currentColor = this.colorSelectTarget.value
    const colors = [...new Set(variantsForSize.map((variant) => String(variant.color)))]

    this.colorSelectTarget.innerHTML = ""

    colors.forEach((color) => {
      const option = document.createElement("option")
      option.value = color
      option.textContent = color
      this.colorSelectTarget.appendChild(option)
    })

    if (colors.includes(currentColor)) {
      this.colorSelectTarget.value = currentColor
    } else if (colors.length > 0) {
      this.colorSelectTarget.value = colors[0]
    }
  }

  selectMatchingVariant() {
    const variant = this.selectedVariant()

    if (!variant) return

    this.variantIdTarget.value = variant.id
  }

  updateQuantityLimit() {
    if (!this.hasQuantityInputTarget) return

    const variant = this.selectedVariant()

    if (!variant) return

    this.quantityInputTarget.max = variant.stock

    const currentQuantity = parseInt(this.quantityInputTarget.value, 10)

    if (currentQuantity > variant.stock) {
      this.quantityInputTarget.value = variant.stock
    }
  }

  selectedVariant() {
    const selectedSize = this.sizeSelectTarget.value
    const selectedColor = this.colorSelectTarget.value

    return this.variantsValue.find((variant) => {
      return String(variant.size) === String(selectedSize) &&
             String(variant.color) === String(selectedColor)
    })
  }

  submitForm() {
    if (!this.hasFormTarget) return

    if (this.formTarget.requestSubmit) {
      this.formTarget.requestSubmit()
    } else {
      this.formTarget.submit()
    }
  }

  showSweetAlert({ title, message, buttonText, onClose = null }) {
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

    closeButton.addEventListener("click", () => this.closeSweetAlert(overlay, onClose))
    actionButton.addEventListener("click", () => this.closeSweetAlert(overlay, onClose))

    overlay.addEventListener("click", (event) => {
      if (event.target === overlay) {
        this.closeSweetAlert(overlay, onClose)
      }
    })

    window.setTimeout(() => {
      overlay.classList.add("is-visible")
    }, 10)
  }

  closeSweetAlert(overlay, onClose = null) {
    if (!overlay || !document.body.contains(overlay)) return
    if (overlay.dataset.closed === "true") return

    overlay.dataset.closed = "true"
    overlay.classList.remove("is-visible")

    window.setTimeout(() => {
      overlay.remove()
      document.body.classList.remove("app-sweet-alert-open")

      if (typeof onClose === "function") {
        onClose()
      }
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
