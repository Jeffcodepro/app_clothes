import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "sizeButton",
    "colorButton",
    "selectedSize",
    "selectedColor",
    "variantId",
    "price"
  ]

  static values = {
    variants: Array
  }

  connect() {
    this.updateAvailability()
    this.updateVariantId()
  }

  selectSize(event) {
    const clickedButton = event.currentTarget
    const size = clickedButton.dataset.size

    if (clickedButton.disabled) return

    if (clickedButton.classList.contains("is-selected")) {
      clickedButton.classList.remove("is-selected")
      this.setSelectedSize("")
    } else {
      this.sizeButtonTargets.forEach((button) => {
        button.classList.remove("is-selected")
      })

      clickedButton.classList.add("is-selected")
      this.setSelectedSize(size)
    }

    this.updateAvailability()
    this.updateVariantId()
  }

  selectColor(event) {
    const clickedButton = event.currentTarget
    const color = clickedButton.dataset.color

    if (clickedButton.disabled) return

    if (clickedButton.classList.contains("is-selected")) {
      clickedButton.classList.remove("is-selected")
      this.setSelectedColor("")
    } else {
      this.colorButtonTargets.forEach((button) => {
        button.classList.remove("is-selected")
      })

      clickedButton.classList.add("is-selected")
      this.setSelectedColor(color)
    }

    this.updateAvailability()
    this.updateVariantId()
  }

  validateBeforeSubmit(event) {
    const selectedSize = this.selectedSize()
    const selectedColor = this.selectedColor()
    const selectedVariant = this.selectedVariant()

    if (selectedSize && selectedColor && selectedVariant) return

    event.preventDefault()

    let message = "Para adicionar esta peça ao carrinho, selecione tamanho e cor."

    if (!selectedSize && selectedColor) {
      message = "Escolha um tamanho disponível antes de adicionar ao carrinho."
    }

    if (selectedSize && !selectedColor) {
      message = "Escolha uma cor disponível antes de adicionar ao carrinho."
    }

    if (selectedSize && selectedColor && !selectedVariant) {
      message = "Essa combinação de tamanho e cor não está disponível no momento."
    }

    this.showSweetAlert({
      title: "Complete a seleção",
      message: message,
      buttonText: "Entendi"
    })
  }

  updateAvailability() {
    const selectedSize = this.selectedSize()
    const selectedColor = this.selectedColor()

    if (this.hasColorButtonTarget) {
      this.colorButtonTargets.forEach((button) => {
        const color = button.dataset.color

        const isAvailable = this.variantsValue.some((variant) => {
          return String(variant.color) === String(color) &&
                 (!selectedSize || String(variant.size) === String(selectedSize)) &&
                 Number(variant.stock) > 0
        })

        button.disabled = !isAvailable

        if (!isAvailable) {
          button.classList.remove("is-selected")
        }
      })
    }

    if (this.hasSizeButtonTarget) {
      this.sizeButtonTargets.forEach((button) => {
        const size = button.dataset.size

        const isAvailable = this.variantsValue.some((variant) => {
          return String(variant.size) === String(size) &&
                 (!selectedColor || String(variant.color) === String(selectedColor)) &&
                 Number(variant.stock) > 0
        })

        button.disabled = !isAvailable

        if (!isAvailable) {
          button.classList.remove("is-selected")
        }
      })
    }

    this.syncSelectedLabels()
  }

  updateVariantId() {
    const variant = this.selectedVariant()

    if (this.hasVariantIdTarget) {
      this.variantIdTarget.value = variant ? variant.id : ""
    }

    if (variant && this.hasPriceTarget) {
      this.priceTarget.textContent = variant.price_label
    }
  }

  selectedVariant() {
    const selectedSize = this.selectedSize()
    const selectedColor = this.selectedColor()

    if (!selectedSize || !selectedColor) return null

    return this.variantsValue.find((variant) => {
      return String(variant.size) === String(selectedSize) &&
             String(variant.color) === String(selectedColor) &&
             Number(variant.stock) > 0
    })
  }

  selectedSize() {
    const selectedButton = this.hasSizeButtonTarget
      ? this.sizeButtonTargets.find((button) => button.classList.contains("is-selected"))
      : null

    return selectedButton ? selectedButton.dataset.size : ""
  }

  selectedColor() {
    const selectedButton = this.hasColorButtonTarget
      ? this.colorButtonTargets.find((button) => button.classList.contains("is-selected"))
      : null

    return selectedButton ? selectedButton.dataset.color : ""
  }

  setSelectedSize(size) {
    if (this.hasSelectedSizeTarget) {
      this.selectedSizeTarget.textContent = size || "Selecione"
    }
  }

  setSelectedColor(color) {
    if (this.hasSelectedColorTarget) {
      this.selectedColorTarget.textContent = color || "Selecione"
    }
  }

  syncSelectedLabels() {
    this.setSelectedSize(this.selectedSize())
    this.setSelectedColor(this.selectedColor())
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
