import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Define targets to reference HTML elements directly without document.getElementById
  static targets = ["input", "container", "removeBtn"]

  connect() {
    this.toggleRemoveButton()
  }

  // Toggles visibility of the 'X' button depending on whether a photo exists
  toggleRemoveButton() {
    if (this.hasRemoveBtnTarget) {
      const currentPhoto = this.element.querySelector("#current-photo")
      this.removeBtnTarget.style.display = currentPhoto ? "block" : "none"
    }
  }

  // Action: Triggered when clicking the frame container
  triggerUpload(event) {
    // Prevent triggering upload if clicking the actual remove button
    if (event.target === this.removeBtnTarget || event.target.closest('#remove-photo-btn')) return

    this.inputTarget.click()
  }

  // Action: Triggered on file input change
  preview(event) {
    const file = event.target.files[0]
    if (!file) return

    if (!file.type.startsWith("image/")) {
      alert("Please select a valid image file.")
      return
    }
    if (file.size > 5 * 1024 * 1024) {
      alert("File is too large. Maximum size is 5MB.")
      return
    }

    const reader = new FileReader()
    reader.onload = (e) => {
      const imageDataUrl = e.target.result
      const currentPhoto = this.element.querySelector("#current-photo")
      const placeholder = this.element.querySelector("#photo-placeholder")

      if (currentPhoto) {
        currentPhoto.src = imageDataUrl
      } else if (placeholder) {
        const newImg = document.createElement("img")
        newImg.src = imageDataUrl
        newImg.className = "w-100 h-100 object-cover"
        newImg.alt = "New Profile Picture"
        newImg.id = "current-photo"

        placeholder.parentNode.replaceChild(newImg, placeholder)
      }

      // Sync the backend checkbox
      const removeCheckbox = this.element.querySelector('input[name*="[remove_photo]"]')
      if (removeCheckbox) removeCheckbox.value = "0"

      this.toggleRemoveButton()
    }
    reader.readAsDataURL(file)
  }

  // Action: Triggered on clicking 'X'
  remove(event) {
    event.stopPropagation() // Prevent bubbling to container click

    const currentPhoto = this.element.querySelector("#current-photo")
    if (currentPhoto) {
      currentPhoto.remove()
    }

    if (!this.element.querySelector("#photo-placeholder")) {
      const newPlaceholder = document.createElement("div")
      newPlaceholder.id = "photo-placeholder"
      newPlaceholder.className = "d-flex align-items-center justify-content-center h-100 bg-light text-muted"
      newPlaceholder.innerHTML = `
        <div class="text-center">
          <p class="mb-1">Photo</p>
          <p class="mb-1">Not</p>
          <p class="mb-0">Available</p>
        </div>
      `
      this.containerTarget.appendChild(newPlaceholder)
    }

    this.inputTarget.value = ""
    
    // Flag the backend to drop the photo
    const removeCheckbox = this.element.querySelector('input[name*="[remove_photo]"]')
    if (removeCheckbox) removeCheckbox.value = "1"

    this.toggleRemoveButton()
  }
}
