// app/javascript/application.js

// Import Turbo and your Stimulus controllers index
import "@hotwired/turbo-rails"
import "./controllers"

// Core Trix dependency must come first
import "trix" 
import "@rails/actiontext"

// Import your custom Trix extensions
import "./trix_extension"
