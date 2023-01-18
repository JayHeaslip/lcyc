import Trix from 'trix';

window.Trix = Trix; // Don't need to bind to the window, but useful for debugging.
Trix.config.toolbar.getDefaultHTML = toolbarDefaultHTML;

// trix-before-initialize runs too early.
// We only need to do this once. Everything after initialize will get the
// defaultHTML() call automatically.
document.addEventListener('trix-initialize', updateToolbars, { once: true });

function updateToolbars(event) {
    const toolbars = document.querySelectorAll('trix-toolbar');
    const html = Trix.config.toolbar.getDefaultHTML();
    toolbars.forEach((toolbar) => (toolbar.innerHTML = html));
}


Trix.config.textAttributes.underline = {
    tagName: 'u',
    inheritable: true,
}

var lang$1 = {
  attachFiles: "Attach Files",
  bold: "Bold",
  bullets: "Bullets",
  byte: "Byte",
  bytes: "Bytes",
  captionPlaceholder: "Add a caption…",
  code: "Code",
  heading1: "Heading",
  indent: "Increase Level",
  italic: "Italic",
  link: "Link",
  numbers: "Numbers",
  outdent: "Decrease Level",
  quote: "Quote",
  redo: "Redo",
  remove: "Remove",
  strike: "Strikethrough",
  underline: "Underline",
  undo: "Undo",
  unlink: "Unlink",
  url: "URL",
  urlPlaceholder: "Enter a URL…",
  GB: "GB",
  KB: "KB",
  MB: "MB",
  PB: "PB",
  TB: "TB"
};

function toolbarDefaultHTML() {
    const {lang} = Trix.config;
    return "<div class=\"trix-button-row\">\n      <span class=\"trix-button-group trix-button-group--text-tools\" data-trix-button-group=\"text-tools\">\n        <button type=\"button\" class=\"trix-button trix-button--icon trix-button--icon-bold\" data-trix-attribute=\"bold\" data-trix-key=\"b\" title=\"".concat(lang$1.bold, "\" tabindex=\"-1\">").concat(lang$1.bold, "</button>\n        <button type=\"button\" class=\"trix-button trix-button--icon trix-button--icon-italic\" data-trix-attribute=\"italic\" data-trix-key=\"i\" title=\"").concat(lang$1.italic, "\" tabindex=\"-1\">").concat(lang$1.italic, "</button>\n        <button type=\"button\" class=\"trix-button trix-button--icon trix-button--icon-strike\" data-trix-attribute=\"strike\" title=\"").concat(lang$1.strike, "\" tabindex=\"-1\">").concat(lang$1.strike, "</button>\n        <button type=\"button\" class=\"trix-button trix-button--icon trix-button--icon-link\" data-trix-attribute=\"href\" data-trix-action=\"link\" data-trix-key=\"k\" title=\"").concat(lang$1.link, "\" tabindex=\"-1\">").concat(lang$1.link, "</button>\n      </span>\n\n      <span class=\"trix-button-group trix-button-group--block-tools\" data-trix-button-group=\"block-tools\">\n        <button type=\"button\" class=\"trix-button trix-button--icon trix-button--icon-heading-1\" data-trix-attribute=\"heading1\" title=\"").concat(lang$1.heading1, "\" tabindex=\"-1\">").concat(lang$1.heading1, "</button>\n        <button type=\"button\" class=\"trix-button trix-button--icon trix-button--icon-quote\" data-trix-attribute=\"quote\" title=\"").concat(lang$1.quote, "\" tabindex=\"-1\">").concat(lang$1.quote, "</button>\n        <button type=\"button\" class=\"trix-button trix-button--icon trix-button--icon-code\" data-trix-attribute=\"code\" title=\"").concat(lang$1.code, "\" tabindex=\"-1\">").concat(lang$1.code, "</button>\n        <button type=\"button\" class=\"trix-button trix-button--icon trix-button--icon-bullet-list\" data-trix-attribute=\"bullet\" title=\"").concat(lang$1.bullets, "\" tabindex=\"-1\">").concat(lang$1.bullets, "</button>\n        <button type=\"button\" class=\"trix-button trix-button--icon trix-button--icon-number-list\" data-trix-attribute=\"number\" title=\"").concat(lang$1.numbers, "\" tabindex=\"-1\">").concat(lang$1.numbers, "</button>\n        <button type=\"button\" class=\"trix-button trix-button--icon trix-button--icon-decrease-nesting-level\" data-trix-action=\"decreaseNestingLevel\" title=\"").concat(lang$1.outdent, "\" tabindex=\"-1\">").concat(lang$1.outdent, "</button>\n        <button type=\"button\" class=\"trix-button trix-button--icon trix-button--icon-increase-nesting-level\" data-trix-action=\"increaseNestingLevel\" title=\"").concat(lang$1.indent, "\" tabindex=\"-1\">").concat(lang$1.indent, "</button>\n      </span>\n\n      <span class=\"trix-button-group-spacer\"></span>\n\n      <span class=\"trix-button-group trix-button-group--history-tools\" data-trix-button-group=\"history-tools\">\n        <button type=\"button\" class=\"trix-button trix-button--icon trix-button--icon-undo\" data-trix-action=\"undo\" data-trix-key=\"z\" title=\"").concat(lang$1.undo, "\" tabindex=\"-1\">").concat(lang$1.undo, "</button>\n        <button type=\"button\" class=\"trix-button trix-button--icon trix-button--icon-redo\" data-trix-action=\"redo\" data-trix-key=\"shift+z\" title=\"").concat(lang$1.redo, "\" tabindex=\"-1\">").concat(lang$1.redo, "</button>\n      </span>\n    </div>\n\n    <div class=\"trix-dialogs\" data-trix-dialogs>\n      <div class=\"trix-dialog trix-dialog--link\" data-trix-dialog=\"href\" data-trix-dialog-attribute=\"href\">\n        <div class=\"trix-dialog__link-fields\">\n          <input type=\"url\" name=\"href\" class=\"trix-input trix-input--dialog\" placeholder=\"").concat(lang$1.urlPlaceholder, "\" aria-label=\"").concat(lang$1.url, "\" required data-trix-input>\n          <div class=\"trix-button-group\">\n            <input type=\"button\" class=\"trix-button trix-button--dialog\" value=\"").concat(lang$1.link, "\" data-trix-method=\"setAttribute\">\n            <input type=\"button\" class=\"trix-button trix-button--dialog\" value=\"").concat(lang$1.unlink, "\" data-trix-method=\"removeAttribute\">\n          </div>\n        </div>\n      </div>\n    </div>");

}
