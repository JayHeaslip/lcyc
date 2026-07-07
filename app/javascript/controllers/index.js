// app/javascript/controllers/index.js

import { Application } from "@hotwired/stimulus"

// Initialize the Stimulus application
const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.stimulus = application

// Import and register your photo preview controller explicitly
import PhotoPreviewController from "./photo_preview_controller"
application.register("photo-preview", PhotoPreviewController)

export { application }
