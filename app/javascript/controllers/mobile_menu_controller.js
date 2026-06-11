import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "overlay", "rootPanel", "genderPanel"]

  open() {
    this.menuTarget.classList.add("is-open")
    this.overlayTarget.classList.add("is-open")
    this.menuTarget.setAttribute("aria-hidden", "false")
    document.body.classList.add("mobile-menu-open")
  }

  close() {
    this.menuTarget.classList.remove("is-open")
    this.overlayTarget.classList.remove("is-open")
    this.menuTarget.setAttribute("aria-hidden", "true")
    document.body.classList.remove("mobile-menu-open")
    this.backToRoot()
  }

  closeWithKeyboard(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  showGender(event) {
    const genderSlug = event.currentTarget.dataset.genderSlug

    this.rootPanelTarget.classList.remove("is-active")

    this.genderPanelTargets.forEach((panel) => {
      panel.classList.toggle("is-active", panel.dataset.genderSlug === genderSlug)
    })
  }

  backToRoot() {
    if (this.hasRootPanelTarget) {
      this.rootPanelTarget.classList.add("is-active")
    }

    if (this.hasGenderPanelTarget) {
      this.genderPanelTargets.forEach((panel) => {
        panel.classList.remove("is-active")
      })
    }
  }
}
