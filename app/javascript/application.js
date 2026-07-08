// app/javascript/application.js

// Import Turbo and your Stimulus controllers index
import "@hotwired/turbo-rails"
import "./controllers"

// Core Trix dependency must come first
import "trix" 
import "@rails/actiontext"

// Import your custom Trix extensions
import "./trix_extension"

// Function to format the string into (xxx) xxx-xxxx
function applyPhoneMask(e) {
  const value = e.target.value;
  if (!value) return;
  
  const phoneNumber = value.replace(/[^\d]/g, '');
  const phoneNumberLength = phoneNumber.length;

  if (phoneNumberLength < 4) {
    e.target.value = phoneNumber;
  } else if (phoneNumberLength < 7) {
    e.target.value = `(${phoneNumber.slice(0, 3)}) ${phoneNumber.slice(3)}`;
  } else {
    e.target.value = `(${phoneNumber.slice(0, 3)}) ${phoneNumber.slice(3, 6)}-${phoneNumber.slice(6, 10)}`;
  }
}

// Listen for Turbo page loads (or DOMContentLoaded if you don't use Turbo)
document.addEventListener("turbo:load", () => {
  const phoneInputs = document.querySelectorAll("input[name*='HomePhone'], input[name*='CellPhone']");
  
  phoneInputs.forEach((input) => {
    // 1. Format the value immediately if there's already a number in it on page load
    if (input.value) {
      // Fake an event object so our existing function can read it
      applyPhoneMask({ target: input }); 
    }

    // 2. Keep listening for user typing
    input.addEventListener("input", applyPhoneMask);
  });
});
