import { Controller } from "@hotwired/stimulus"

const AVAILABILITY_NOTIFICATIONS_API_PATH = "/api/v3/availability_notifications"

export default class extends Controller {
  static targets = [
    "panel",
    "form",
    "formContent",
    "successContent",
    "emailInput",
    "status",
    "submitButton",
    "skuInput",
    "optionsFields"
  ]

  static values = {
    panelId: String
  }

  async open(event) {
    event?.preventDefault()
    event?.stopPropagation()

    this.showFormView()

    const panel = this.panelTarget

    if (!panel?.open) return

    await panel.open()

    if (this.hasEmailInputTarget) {
      this.emailInputTarget.focus()
    }
  }

  async close(event) {
    event?.preventDefault()
    event?.stopPropagation()

    const panel = this.panelTarget

    if (!panel?.close) return

    await panel.close()
    this.showFormView()
  }

  async closeParentSidepanel(trigger) {
    if (!trigger?.closest) return

    const parentPanel = trigger.closest("yes-sidepanel")

    if (!parentPanel || parentPanel === this.panelTarget) return
    if (!parentPanel.close) return

    await parentPanel.close()
  }

  async submit(event) {
    event.preventDefault()

    if (!this.formTarget.reportValidity()) return

    this.setLoading(true)
    this.clearStatus()

    try {
      const response = await fetch(AVAILABILITY_NOTIFICATIONS_API_PATH, {
        method: "POST",
        credentials: "same-origin",
        headers: {
          "Accept": "application/json"
        },
        body: new FormData(this.formTarget)
      })

      if (!response.ok) {
        throw new Error("Availability notification request failed")
      }

      this.formTarget.reset()
      this.showSuccessView()
    } catch {
      this.showStatus("Something went wrong. Try again.")
    } finally {
      this.setLoading(false)
    }
  }

  async openForVariant(event) {
    event?.preventDefault()
    event?.stopPropagation()

    await this.closeParentSidepanel(event?.currentTarget)

    const sku = event.params.sku
    const options = this.parseOptions(event.params.options)

    if (this.hasSkuInputTarget && sku) {
      this.skuInputTarget.value = sku
    }

    this.replaceOptions(options)

    await this.open(event)
  }

  replaceOptions(options) {
    if (!this.hasOptionsFieldsTarget) return

    this.optionsFieldsTarget.replaceChildren()

    Object.entries(options).forEach(([name, value]) => {
      const input = document.createElement("input")

      input.type = "hidden"
      input.name = `availability_notification[variant][options][${name}]`
      input.value = value

      this.optionsFieldsTarget.appendChild(input)
    })
  }

  parseOptions(options) {
    if (!options) return {}
    if (typeof options === "object") return options

    try {
      return JSON.parse(options)
    } catch {
      return {}
    }
  }

  showFormView() {
    if (this.hasFormContentTarget) {
      this.formContentTarget.hidden = false
    }

    if (this.hasSuccessContentTarget) {
      this.successContentTarget.hidden = true
    }

    this.clearStatus()
  }

  showSuccessView() {
    if (this.hasFormContentTarget) {
      this.formContentTarget.hidden = true
    }

    if (this.hasSuccessContentTarget) {
      this.successContentTarget.hidden = false
    }
  }

  setLoading(isLoading) {
    if (!this.hasSubmitButtonTarget) return

    this.submitButtonTarget.disabled = isLoading
  }

  clearStatus() {
    if (!this.hasStatusTarget) return

    this.statusTarget.hidden = true
    this.statusTarget.textContent = ""
  }

  showStatus(message) {
    if (!this.hasStatusTarget) return

    this.statusTarget.hidden = false
    this.statusTarget.textContent = message
  }
}
