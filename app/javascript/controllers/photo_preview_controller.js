import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "container", "removeBtn", "image", "placeholder", "removeCheckbox"]

    connect() {
	this.toggleRemoveButton()
    }

  // Toggles visibility of the 'X' button depending on whether a valid image is shown
    toggleRemoveButton() {
	if (this.hasRemoveBtnTarget) {
	    // Check if image exists, has a src, and isn't hidden with d-none
	    const hasImage = this.hasImageTarget && 
                  this.imageTarget.src !== "" && 
                  !this.imageTarget.src.endsWith("/") && 
                !this.imageTarget.classList.contains('d-none')
            
	    this.removeBtnTarget.style.setProperty("display", hasImage ? "block" : "none", "important")
	}
    }
    
    // Action: Triggered when clicking the frame container
    triggerUpload(event) {
	// Safely check if the remove button even exists in the DOM first
	if (this.hasRemoveBtnTarget) {
	    // Prevent triggering upload if clicking the actual remove button or its contents
	    if (event.target === this.removeBtnTarget || this.removeBtnTarget.contains(event.target)) {
		return
	    }
	}
	
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
	    
	    if (this.hasImageTarget) {
		this.imageTarget.src = imageDataUrl
		this.imageTarget.classList.remove('d-none')
	    }
	    
	    if (this.hasPlaceholderTarget) {
		this.placeholderTarget.classList.add('d-none')
	    }
	    
	    // Uncheck / reset the backend deletion flag
	    if (this.hasRemoveCheckboxTarget) {
		this.removeCheckboxTarget.value = "0"
		this.removeCheckboxTarget.checked = false
	    }
	    
	    this.toggleRemoveButton()
	}
	reader.readAsDataURL(file)
    }
    
    // Action: Triggered on clicking 'X'
    remove(event) {
	event.stopPropagation() // Prevent bubbling up to triggerUpload
	
	if (this.hasImageTarget) {
	    this.imageTarget.src = ""
	    this.imageTarget.classList.add('d-none')
	}
	
	if (this.hasPlaceholderTarget) {
	    this.placeholderTarget.classList.remove('d-none')
	}
	
	// Reset file input value so the same file can be re-uploaded later if desired
	this.inputTarget.value = ""
	
	// Flag the backend to drop the photo
	if (this.hasRemoveCheckboxTarget) {
	    this.removeCheckboxTarget.value = "1"
	    this.removeCheckboxTarget.checked = true
	}
	
	this.toggleRemoveButton()
    }
}
