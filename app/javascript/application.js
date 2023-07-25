// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import "trix"
import "@rails/actiontext"
import "./trix_extension"

const allowedImageTypes = ["image/png", "image/jpg", "image/jpeg", "image/gif"]

document.addEventListener("trix-file-accept", e => {
    if (allowedImageTypes.includes(e.file.type)) {
	console.log("attach");
    } else {
	e.preventDefault();
	console.log("reject");
	alert("Unsupported file type: Must be .jpeg, .jpg or .png");
    }
})
