(() => {
  // node_modules/trix/dist/trix.esm.min.js
  var t = "2.1.4";
  var e = "[data-trix-attachment]";
  var i = { preview: { presentation: "gallery", caption: { name: true, size: true } }, file: { caption: { size: true } } };
  var n = { default: { tagName: "div", parse: false }, quote: { tagName: "blockquote", nestable: true }, heading1: { tagName: "h1", terminal: true, breakOnReturn: true, group: false }, code: { tagName: "pre", terminal: true, htmlAttributes: ["language"], text: { plaintext: true } }, bulletList: { tagName: "ul", parse: false }, bullet: { tagName: "li", listAttribute: "bulletList", group: false, nestable: true, test(t2) {
    return r(t2.parentNode) === n[this.listAttribute].tagName;
  } }, numberList: { tagName: "ol", parse: false }, number: { tagName: "li", listAttribute: "numberList", group: false, nestable: true, test(t2) {
    return r(t2.parentNode) === n[this.listAttribute].tagName;
  } }, attachmentGallery: { tagName: "div", exclusive: true, terminal: true, parse: false, group: false } };
  var r = (t2) => {
    var e2;
    return null == t2 || null === (e2 = t2.tagName) || void 0 === e2 ? void 0 : e2.toLowerCase();
  };
  var o = navigator.userAgent.match(/android\s([0-9]+.*Chrome)/i);
  var s = o && parseInt(o[1]);
  var a = { composesExistingText: /Android.*Chrome/.test(navigator.userAgent), recentAndroid: s && s > 12, samsungAndroid: s && navigator.userAgent.match(/Android.*SM-/), forcesObjectResizing: /Trident.*rv:11/.test(navigator.userAgent), supportsInputEvents: "undefined" != typeof InputEvent && ["data", "getTargetRanges", "inputType"].every((t2) => t2 in InputEvent.prototype) };
  var l = { attachFiles: "Attach Files", bold: "Bold", bullets: "Bullets", byte: "Byte", bytes: "Bytes", captionPlaceholder: "Add a caption\u2026", code: "Code", heading1: "Heading", indent: "Increase Level", italic: "Italic", link: "Link", numbers: "Numbers", outdent: "Decrease Level", quote: "Quote", redo: "Redo", remove: "Remove", strike: "Strikethrough", undo: "Undo", unlink: "Unlink", url: "URL", urlPlaceholder: "Enter a URL\u2026", GB: "GB", KB: "KB", MB: "MB", PB: "PB", TB: "TB" };
  var c = [l.bytes, l.KB, l.MB, l.GB, l.TB, l.PB];
  var u = { prefix: "IEC", precision: 2, formatter(t2) {
    switch (t2) {
      case 0:
        return "0 ".concat(l.bytes);
      case 1:
        return "1 ".concat(l.byte);
      default:
        let e2;
        "SI" === this.prefix ? e2 = 1e3 : "IEC" === this.prefix && (e2 = 1024);
        const i2 = Math.floor(Math.log(t2) / Math.log(e2)), n2 = (t2 / Math.pow(e2, i2)).toFixed(this.precision).replace(/0*$/, "").replace(/\.$/, "");
        return "".concat(n2, " ").concat(c[i2]);
    }
  } };
  var h = "\uFEFF";
  var d = "\xA0";
  var g = function(t2) {
    for (const e2 in t2) {
      const i2 = t2[e2];
      this[e2] = i2;
    }
    return this;
  };
  var m = document.documentElement;
  var p = m.matches;
  var f = function(t2) {
    let { onElement: e2, matchingSelector: i2, withCallback: n2, inPhase: r2, preventDefault: o2, times: s2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
    const a2 = e2 || m, l2 = i2, c2 = "capturing" === r2, u2 = function(t3) {
      null != s2 && 0 == --s2 && u2.destroy();
      const e3 = A(t3.target, { matchingSelector: l2 });
      null != e3 && (null == n2 || n2.call(e3, t3, e3), o2 && t3.preventDefault());
    };
    return u2.destroy = () => a2.removeEventListener(t2, u2, c2), a2.addEventListener(t2, u2, c2), u2;
  };
  var b = function(t2) {
    let { onElement: e2, bubbles: i2, cancelable: n2, attributes: r2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
    const o2 = null != e2 ? e2 : m;
    i2 = false !== i2, n2 = false !== n2;
    const s2 = document.createEvent("Events");
    return s2.initEvent(t2, i2, n2), null != r2 && g.call(s2, r2), o2.dispatchEvent(s2);
  };
  var v = function(t2, e2) {
    if (1 === (null == t2 ? void 0 : t2.nodeType))
      return p.call(t2, e2);
  };
  var A = function(t2) {
    let { matchingSelector: e2, untilNode: i2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
    for (; t2 && t2.nodeType !== Node.ELEMENT_NODE; )
      t2 = t2.parentNode;
    if (null != t2) {
      if (null == e2)
        return t2;
      if (t2.closest && null == i2)
        return t2.closest(e2);
      for (; t2 && t2 !== i2; ) {
        if (v(t2, e2))
          return t2;
        t2 = t2.parentNode;
      }
    }
  };
  var x = (t2) => document.activeElement !== t2 && y(t2, document.activeElement);
  var y = function(t2, e2) {
    if (t2 && e2)
      for (; e2; ) {
        if (e2 === t2)
          return true;
        e2 = e2.parentNode;
      }
  };
  var C = function(t2) {
    var e2;
    if (null === (e2 = t2) || void 0 === e2 || !e2.parentNode)
      return;
    let i2 = 0;
    for (t2 = t2.previousSibling; t2; )
      i2++, t2 = t2.previousSibling;
    return i2;
  };
  var k = (t2) => {
    var e2;
    return null == t2 || null === (e2 = t2.parentNode) || void 0 === e2 ? void 0 : e2.removeChild(t2);
  };
  var R = function(t2) {
    let { onlyNodesOfType: e2, usingFilter: i2, expandEntityReferences: n2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
    const r2 = (() => {
      switch (e2) {
        case "element":
          return NodeFilter.SHOW_ELEMENT;
        case "text":
          return NodeFilter.SHOW_TEXT;
        case "comment":
          return NodeFilter.SHOW_COMMENT;
        default:
          return NodeFilter.SHOW_ALL;
      }
    })();
    return document.createTreeWalker(t2, r2, null != i2 ? i2 : null, true === n2);
  };
  var E = (t2) => {
    var e2;
    return null == t2 || null === (e2 = t2.tagName) || void 0 === e2 ? void 0 : e2.toLowerCase();
  };
  var S = function(t2) {
    let e2, i2, n2 = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
    "object" == typeof t2 ? (n2 = t2, t2 = n2.tagName) : n2 = { attributes: n2 };
    const r2 = document.createElement(t2);
    if (null != n2.editable && (null == n2.attributes && (n2.attributes = {}), n2.attributes.contenteditable = n2.editable), n2.attributes)
      for (e2 in n2.attributes)
        i2 = n2.attributes[e2], r2.setAttribute(e2, i2);
    if (n2.style)
      for (e2 in n2.style)
        i2 = n2.style[e2], r2.style[e2] = i2;
    if (n2.data)
      for (e2 in n2.data)
        i2 = n2.data[e2], r2.dataset[e2] = i2;
    return n2.className && n2.className.split(" ").forEach((t3) => {
      r2.classList.add(t3);
    }), n2.textContent && (r2.textContent = n2.textContent), n2.childNodes && [].concat(n2.childNodes).forEach((t3) => {
      r2.appendChild(t3);
    }), r2;
  };
  var L;
  var D = function() {
    if (null != L)
      return L;
    L = [];
    for (const t2 in n) {
      const e2 = n[t2];
      e2.tagName && L.push(e2.tagName);
    }
    return L;
  };
  var w = (t2) => B(null == t2 ? void 0 : t2.firstChild);
  var T = function(t2) {
    let { strict: e2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : { strict: true };
    return e2 ? B(t2) : B(t2) || !B(t2.firstChild) && function(t3) {
      return D().includes(E(t3)) && !D().includes(E(t3.firstChild));
    }(t2);
  };
  var B = (t2) => F(t2) && "block" === (null == t2 ? void 0 : t2.data);
  var F = (t2) => (null == t2 ? void 0 : t2.nodeType) === Node.COMMENT_NODE;
  var P = function(t2) {
    let { name: e2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
    if (t2)
      return O(t2) ? t2.data === h ? !e2 || t2.parentNode.dataset.trixCursorTarget === e2 : void 0 : P(t2.firstChild);
  };
  var I = (t2) => v(t2, e);
  var N = (t2) => O(t2) && "" === (null == t2 ? void 0 : t2.data);
  var O = (t2) => (null == t2 ? void 0 : t2.nodeType) === Node.TEXT_NODE;
  var M = { level2Enabled: true, getLevel() {
    return this.level2Enabled && a.supportsInputEvents ? 2 : 0;
  }, pickFiles(t2) {
    const e2 = S("input", { type: "file", multiple: true, hidden: true, id: this.fileInputId });
    e2.addEventListener("change", () => {
      t2(e2.files), k(e2);
    }), k(document.getElementById(this.fileInputId)), document.body.appendChild(e2), e2.click();
  } };
  var j = { removeBlankTableCells: false, tableCellSeparator: " | ", tableRowSeparator: "\n" };
  var W = { bold: { tagName: "strong", inheritable: true, parser(t2) {
    const e2 = window.getComputedStyle(t2);
    return "bold" === e2.fontWeight || e2.fontWeight >= 600;
  } }, italic: { tagName: "em", inheritable: true, parser: (t2) => "italic" === window.getComputedStyle(t2).fontStyle }, href: { groupTagName: "a", parser(t2) {
    const i2 = "a:not(".concat(e, ")"), n2 = t2.closest(i2);
    if (n2)
      return n2.getAttribute("href");
  } }, strike: { tagName: "del", inheritable: true }, frozen: { style: { backgroundColor: "highlight" } } };
  var U = { getDefaultHTML: () => '<div class="trix-button-row">\n      <span class="trix-button-group trix-button-group--text-tools" data-trix-button-group="text-tools">\n        <button type="button" class="trix-button trix-button--icon trix-button--icon-bold" data-trix-attribute="bold" data-trix-key="b" title="'.concat(l.bold, '" tabindex="-1">').concat(l.bold, '</button>\n        <button type="button" class="trix-button trix-button--icon trix-button--icon-italic" data-trix-attribute="italic" data-trix-key="i" title="').concat(l.italic, '" tabindex="-1">').concat(l.italic, '</button>\n        <button type="button" class="trix-button trix-button--icon trix-button--icon-strike" data-trix-attribute="strike" title="').concat(l.strike, '" tabindex="-1">').concat(l.strike, '</button>\n        <button type="button" class="trix-button trix-button--icon trix-button--icon-link" data-trix-attribute="href" data-trix-action="link" data-trix-key="k" title="').concat(l.link, '" tabindex="-1">').concat(l.link, '</button>\n      </span>\n\n      <span class="trix-button-group trix-button-group--block-tools" data-trix-button-group="block-tools">\n        <button type="button" class="trix-button trix-button--icon trix-button--icon-heading-1" data-trix-attribute="heading1" title="').concat(l.heading1, '" tabindex="-1">').concat(l.heading1, '</button>\n        <button type="button" class="trix-button trix-button--icon trix-button--icon-quote" data-trix-attribute="quote" title="').concat(l.quote, '" tabindex="-1">').concat(l.quote, '</button>\n        <button type="button" class="trix-button trix-button--icon trix-button--icon-code" data-trix-attribute="code" title="').concat(l.code, '" tabindex="-1">').concat(l.code, '</button>\n        <button type="button" class="trix-button trix-button--icon trix-button--icon-bullet-list" data-trix-attribute="bullet" title="').concat(l.bullets, '" tabindex="-1">').concat(l.bullets, '</button>\n        <button type="button" class="trix-button trix-button--icon trix-button--icon-number-list" data-trix-attribute="number" title="').concat(l.numbers, '" tabindex="-1">').concat(l.numbers, '</button>\n        <button type="button" class="trix-button trix-button--icon trix-button--icon-decrease-nesting-level" data-trix-action="decreaseNestingLevel" title="').concat(l.outdent, '" tabindex="-1">').concat(l.outdent, '</button>\n        <button type="button" class="trix-button trix-button--icon trix-button--icon-increase-nesting-level" data-trix-action="increaseNestingLevel" title="').concat(l.indent, '" tabindex="-1">').concat(l.indent, '</button>\n      </span>\n\n      <span class="trix-button-group trix-button-group--file-tools" data-trix-button-group="file-tools">\n        <button type="button" class="trix-button trix-button--icon trix-button--icon-attach" data-trix-action="attachFiles" title="').concat(l.attachFiles, '" tabindex="-1">').concat(l.attachFiles, '</button>\n      </span>\n\n      <span class="trix-button-group-spacer"></span>\n\n      <span class="trix-button-group trix-button-group--history-tools" data-trix-button-group="history-tools">\n        <button type="button" class="trix-button trix-button--icon trix-button--icon-undo" data-trix-action="undo" data-trix-key="z" title="').concat(l.undo, '" tabindex="-1">').concat(l.undo, '</button>\n        <button type="button" class="trix-button trix-button--icon trix-button--icon-redo" data-trix-action="redo" data-trix-key="shift+z" title="').concat(l.redo, '" tabindex="-1">').concat(l.redo, '</button>\n      </span>\n    </div>\n\n    <div class="trix-dialogs" data-trix-dialogs>\n      <div class="trix-dialog trix-dialog--link" data-trix-dialog="href" data-trix-dialog-attribute="href">\n        <div class="trix-dialog__link-fields">\n          <input type="url" name="href" class="trix-input trix-input--dialog" placeholder="').concat(l.urlPlaceholder, '" aria-label="').concat(l.url, '" required data-trix-input>\n          <div class="trix-button-group">\n            <input type="button" class="trix-button trix-button--dialog" value="').concat(l.link, '" data-trix-method="setAttribute">\n            <input type="button" class="trix-button trix-button--dialog" value="').concat(l.unlink, '" data-trix-method="removeAttribute">\n          </div>\n        </div>\n      </div>\n    </div>') };
  var q = { interval: 5e3 };
  var V = Object.freeze({ __proto__: null, attachments: i, blockAttributes: n, browser: a, css: { attachment: "attachment", attachmentCaption: "attachment__caption", attachmentCaptionEditor: "attachment__caption-editor", attachmentMetadata: "attachment__metadata", attachmentMetadataContainer: "attachment__metadata-container", attachmentName: "attachment__name", attachmentProgress: "attachment__progress", attachmentSize: "attachment__size", attachmentToolbar: "attachment__toolbar", attachmentGallery: "attachment-gallery" }, fileSize: u, input: M, keyNames: { 8: "backspace", 9: "tab", 13: "return", 27: "escape", 37: "left", 39: "right", 46: "delete", 68: "d", 72: "h", 79: "o" }, lang: l, parser: j, textAttributes: W, toolbar: U, undo: q });
  var H = class {
    static proxyMethod(t2) {
      const { name: e2, toMethod: i2, toProperty: n2, optional: r2 } = z(t2);
      this.prototype[e2] = function() {
        let t3, o2;
        var s2, a2;
        i2 ? o2 = r2 ? null === (s2 = this[i2]) || void 0 === s2 ? void 0 : s2.call(this) : this[i2]() : n2 && (o2 = this[n2]);
        return r2 ? (t3 = null === (a2 = o2) || void 0 === a2 ? void 0 : a2[e2], t3 ? _.call(t3, o2, arguments) : void 0) : (t3 = o2[e2], _.call(t3, o2, arguments));
      };
    }
  };
  var z = function(t2) {
    const e2 = t2.match(J);
    if (!e2)
      throw new Error("can't parse @proxyMethod expression: ".concat(t2));
    const i2 = { name: e2[4] };
    return null != e2[2] ? i2.toMethod = e2[1] : i2.toProperty = e2[1], null != e2[3] && (i2.optional = true), i2;
  };
  var { apply: _ } = Function.prototype;
  var J = new RegExp("^(.+?)(\\(\\))?(\\?)?\\.(.+?)$");
  var K;
  var G;
  var $;
  var X = class extends H {
    static box() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : "";
      return t2 instanceof this ? t2 : this.fromUCS2String(null == t2 ? void 0 : t2.toString());
    }
    static fromUCS2String(t2) {
      return new this(t2, tt(t2));
    }
    static fromCodepoints(t2) {
      return new this(et(t2), t2);
    }
    constructor(t2, e2) {
      super(...arguments), this.ucs2String = t2, this.codepoints = e2, this.length = this.codepoints.length, this.ucs2Length = this.ucs2String.length;
    }
    offsetToUCS2Offset(t2) {
      return et(this.codepoints.slice(0, Math.max(0, t2))).length;
    }
    offsetFromUCS2Offset(t2) {
      return tt(this.ucs2String.slice(0, Math.max(0, t2))).length;
    }
    slice() {
      return this.constructor.fromCodepoints(this.codepoints.slice(...arguments));
    }
    charAt(t2) {
      return this.slice(t2, t2 + 1);
    }
    isEqualTo(t2) {
      return this.constructor.box(t2).ucs2String === this.ucs2String;
    }
    toJSON() {
      return this.ucs2String;
    }
    getCacheKey() {
      return this.ucs2String;
    }
    toString() {
      return this.ucs2String;
    }
  };
  var Y = 1 === (null === (K = Array.from) || void 0 === K ? void 0 : K.call(Array, "\u{1F47C}").length);
  var Q = null != (null === (G = " ".codePointAt) || void 0 === G ? void 0 : G.call(" ", 0));
  var Z = " \u{1F47C}" === (null === ($ = String.fromCodePoint) || void 0 === $ ? void 0 : $.call(String, 32, 128124));
  var tt;
  var et;
  tt = Y && Q ? (t2) => Array.from(t2).map((t3) => t3.codePointAt(0)) : function(t2) {
    const e2 = [];
    let i2 = 0;
    const { length: n2 } = t2;
    for (; i2 < n2; ) {
      let r2 = t2.charCodeAt(i2++);
      if (55296 <= r2 && r2 <= 56319 && i2 < n2) {
        const e3 = t2.charCodeAt(i2++);
        56320 == (64512 & e3) ? r2 = ((1023 & r2) << 10) + (1023 & e3) + 65536 : i2--;
      }
      e2.push(r2);
    }
    return e2;
  }, et = Z ? (t2) => String.fromCodePoint(...Array.from(t2 || [])) : function(t2) {
    return (() => {
      const e2 = [];
      return Array.from(t2).forEach((t3) => {
        let i2 = "";
        t3 > 65535 && (t3 -= 65536, i2 += String.fromCharCode(t3 >>> 10 & 1023 | 55296), t3 = 56320 | 1023 & t3), e2.push(i2 + String.fromCharCode(t3));
      }), e2;
    })().join("");
  };
  var it = 0;
  var nt = class extends H {
    static fromJSONString(t2) {
      return this.fromJSON(JSON.parse(t2));
    }
    constructor() {
      super(...arguments), this.id = ++it;
    }
    hasSameConstructorAs(t2) {
      return this.constructor === (null == t2 ? void 0 : t2.constructor);
    }
    isEqualTo(t2) {
      return this === t2;
    }
    inspect() {
      const t2 = [], e2 = this.contentsForInspection() || {};
      for (const i2 in e2) {
        const n2 = e2[i2];
        t2.push("".concat(i2, "=").concat(n2));
      }
      return "#<".concat(this.constructor.name, ":").concat(this.id).concat(t2.length ? " ".concat(t2.join(", ")) : "", ">");
    }
    contentsForInspection() {
    }
    toJSONString() {
      return JSON.stringify(this);
    }
    toUTF16String() {
      return X.box(this);
    }
    getCacheKey() {
      return this.id.toString();
    }
  };
  var rt = function() {
    let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : [], e2 = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : [];
    if (t2.length !== e2.length)
      return false;
    for (let i2 = 0; i2 < t2.length; i2++) {
      if (t2[i2] !== e2[i2])
        return false;
    }
    return true;
  };
  var ot = function(t2) {
    const e2 = t2.slice(0);
    for (var i2 = arguments.length, n2 = new Array(i2 > 1 ? i2 - 1 : 0), r2 = 1; r2 < i2; r2++)
      n2[r2 - 1] = arguments[r2];
    return e2.splice(...n2), e2;
  };
  var st = /[\u05BE\u05C0\u05C3\u05D0-\u05EA\u05F0-\u05F4\u061B\u061F\u0621-\u063A\u0640-\u064A\u066D\u0671-\u06B7\u06BA-\u06BE\u06C0-\u06CE\u06D0-\u06D5\u06E5\u06E6\u200F\u202B\u202E\uFB1F-\uFB28\uFB2A-\uFB36\uFB38-\uFB3C\uFB3E\uFB40\uFB41\uFB43\uFB44\uFB46-\uFBB1\uFBD3-\uFD3D\uFD50-\uFD8F\uFD92-\uFDC7\uFDF0-\uFDFB\uFE70-\uFE72\uFE74\uFE76-\uFEFC]/;
  var at = function() {
    const t2 = S("input", { dir: "auto", name: "x", dirName: "x.dir" }), e2 = S("textarea", { dir: "auto", name: "y", dirName: "y.dir" }), i2 = S("form");
    i2.appendChild(t2), i2.appendChild(e2);
    const n2 = function() {
      try {
        return new FormData(i2).has(e2.dirName);
      } catch (t3) {
        return false;
      }
    }(), r2 = function() {
      try {
        return t2.matches(":dir(ltr),:dir(rtl)");
      } catch (t3) {
        return false;
      }
    }();
    return n2 ? function(t3) {
      return e2.value = t3, new FormData(i2).get(e2.dirName);
    } : r2 ? function(e3) {
      return t2.value = e3, t2.matches(":dir(rtl)") ? "rtl" : "ltr";
    } : function(t3) {
      const e3 = t3.trim().charAt(0);
      return st.test(e3) ? "rtl" : "ltr";
    };
  }();
  var lt = null;
  var ct = null;
  var ut = null;
  var ht = null;
  var dt = () => (lt || (lt = ft().concat(mt())), lt);
  var gt = (t2) => n[t2];
  var mt = () => (ct || (ct = Object.keys(n)), ct);
  var pt = (t2) => W[t2];
  var ft = () => (ut || (ut = Object.keys(W)), ut);
  var bt = function(t2, e2) {
    vt(t2).textContent = e2.replace(/%t/g, t2);
  };
  var vt = function(t2) {
    const e2 = document.createElement("style");
    e2.setAttribute("type", "text/css"), e2.setAttribute("data-tag-name", t2.toLowerCase());
    const i2 = At();
    return i2 && e2.setAttribute("nonce", i2), document.head.insertBefore(e2, document.head.firstChild), e2;
  };
  var At = function() {
    const t2 = xt("trix-csp-nonce") || xt("csp-nonce");
    if (t2)
      return t2.getAttribute("content");
  };
  var xt = (t2) => document.head.querySelector("meta[name=".concat(t2, "]"));
  var yt = { "application/x-trix-feature-detection": "test" };
  var Ct = function(t2) {
    const e2 = t2.getData("text/plain"), i2 = t2.getData("text/html");
    if (!e2 || !i2)
      return null == e2 ? void 0 : e2.length;
    {
      const { body: t3 } = new DOMParser().parseFromString(i2, "text/html");
      if (t3.textContent === e2)
        return !t3.querySelector("*");
    }
  };
  var kt = /Mac|^iP/.test(navigator.platform) ? (t2) => t2.metaKey : (t2) => t2.ctrlKey;
  var Rt = (t2) => setTimeout(t2, 1);
  var Et = function() {
    let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {};
    const e2 = {};
    for (const i2 in t2) {
      const n2 = t2[i2];
      e2[i2] = n2;
    }
    return e2;
  };
  var St = function() {
    let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {}, e2 = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
    if (Object.keys(t2).length !== Object.keys(e2).length)
      return false;
    for (const i2 in t2) {
      if (t2[i2] !== e2[i2])
        return false;
    }
    return true;
  };
  var Lt = function(t2) {
    if (null != t2)
      return Array.isArray(t2) || (t2 = [t2, t2]), [Tt(t2[0]), Tt(null != t2[1] ? t2[1] : t2[0])];
  };
  var Dt = function(t2) {
    if (null == t2)
      return;
    const [e2, i2] = Lt(t2);
    return Bt(e2, i2);
  };
  var wt = function(t2, e2) {
    if (null == t2 || null == e2)
      return;
    const [i2, n2] = Lt(t2), [r2, o2] = Lt(e2);
    return Bt(i2, r2) && Bt(n2, o2);
  };
  var Tt = function(t2) {
    return "number" == typeof t2 ? t2 : Et(t2);
  };
  var Bt = function(t2, e2) {
    return "number" == typeof t2 ? t2 === e2 : St(t2, e2);
  };
  var Ft = class extends H {
    constructor() {
      super(...arguments), this.update = this.update.bind(this), this.selectionManagers = [];
    }
    start() {
      this.started || (this.started = true, document.addEventListener("selectionchange", this.update, true));
    }
    stop() {
      if (this.started)
        return this.started = false, document.removeEventListener("selectionchange", this.update, true);
    }
    registerSelectionManager(t2) {
      if (!this.selectionManagers.includes(t2))
        return this.selectionManagers.push(t2), this.start();
    }
    unregisterSelectionManager(t2) {
      if (this.selectionManagers = this.selectionManagers.filter((e2) => e2 !== t2), 0 === this.selectionManagers.length)
        return this.stop();
    }
    notifySelectionManagersOfSelectionChange() {
      return this.selectionManagers.map((t2) => t2.selectionDidChange());
    }
    update() {
      this.notifySelectionManagersOfSelectionChange();
    }
    reset() {
      this.update();
    }
  };
  var Pt = new Ft();
  var It = function() {
    const t2 = window.getSelection();
    if (t2.rangeCount > 0)
      return t2;
  };
  var Nt = function() {
    var t2;
    const e2 = null === (t2 = It()) || void 0 === t2 ? void 0 : t2.getRangeAt(0);
    if (e2 && !Mt(e2))
      return e2;
  };
  var Ot = function(t2) {
    const e2 = window.getSelection();
    return e2.removeAllRanges(), e2.addRange(t2), Pt.update();
  };
  var Mt = (t2) => jt(t2.startContainer) || jt(t2.endContainer);
  var jt = (t2) => !Object.getPrototypeOf(t2);
  var Wt = (t2) => t2.replace(new RegExp("".concat(h), "g"), "").replace(new RegExp("".concat(d), "g"), " ");
  var Ut = new RegExp("[^\\S".concat(d, "]"));
  var qt = (t2) => t2.replace(new RegExp("".concat(Ut.source), "g"), " ").replace(/\ {2,}/g, " ");
  var Vt = function(t2, e2) {
    if (t2.isEqualTo(e2))
      return ["", ""];
    const i2 = Ht(t2, e2), { length: n2 } = i2.utf16String;
    let r2;
    if (n2) {
      const { offset: o2 } = i2, s2 = t2.codepoints.slice(0, o2).concat(t2.codepoints.slice(o2 + n2));
      r2 = Ht(e2, X.fromCodepoints(s2));
    } else
      r2 = Ht(e2, t2);
    return [i2.utf16String.toString(), r2.utf16String.toString()];
  };
  var Ht = function(t2, e2) {
    let i2 = 0, n2 = t2.length, r2 = e2.length;
    for (; i2 < n2 && t2.charAt(i2).isEqualTo(e2.charAt(i2)); )
      i2++;
    for (; n2 > i2 + 1 && t2.charAt(n2 - 1).isEqualTo(e2.charAt(r2 - 1)); )
      n2--, r2--;
    return { utf16String: t2.slice(i2, n2), offset: i2 };
  };
  var zt = class extends nt {
    static fromCommonAttributesOfObjects() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : [];
      if (!t2.length)
        return new this();
      let e2 = Gt(t2[0]), i2 = e2.getKeys();
      return t2.slice(1).forEach((t3) => {
        i2 = e2.getKeysCommonToHash(Gt(t3)), e2 = e2.slice(i2);
      }), e2;
    }
    static box(t2) {
      return Gt(t2);
    }
    constructor() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {};
      super(...arguments), this.values = Kt(t2);
    }
    add(t2, e2) {
      return this.merge(_t(t2, e2));
    }
    remove(t2) {
      return new zt(Kt(this.values, t2));
    }
    get(t2) {
      return this.values[t2];
    }
    has(t2) {
      return t2 in this.values;
    }
    merge(t2) {
      return new zt(Jt(this.values, $t(t2)));
    }
    slice(t2) {
      const e2 = {};
      return Array.from(t2).forEach((t3) => {
        this.has(t3) && (e2[t3] = this.values[t3]);
      }), new zt(e2);
    }
    getKeys() {
      return Object.keys(this.values);
    }
    getKeysCommonToHash(t2) {
      return t2 = Gt(t2), this.getKeys().filter((e2) => this.values[e2] === t2.values[e2]);
    }
    isEqualTo(t2) {
      return rt(this.toArray(), Gt(t2).toArray());
    }
    isEmpty() {
      return 0 === this.getKeys().length;
    }
    toArray() {
      if (!this.array) {
        const t2 = [];
        for (const e2 in this.values) {
          const i2 = this.values[e2];
          t2.push(t2.push(e2, i2));
        }
        this.array = t2.slice(0);
      }
      return this.array;
    }
    toObject() {
      return Kt(this.values);
    }
    toJSON() {
      return this.toObject();
    }
    contentsForInspection() {
      return { values: JSON.stringify(this.values) };
    }
  };
  var _t = function(t2, e2) {
    const i2 = {};
    return i2[t2] = e2, i2;
  };
  var Jt = function(t2, e2) {
    const i2 = Kt(t2);
    for (const t3 in e2) {
      const n2 = e2[t3];
      i2[t3] = n2;
    }
    return i2;
  };
  var Kt = function(t2, e2) {
    const i2 = {};
    return Object.keys(t2).sort().forEach((n2) => {
      n2 !== e2 && (i2[n2] = t2[n2]);
    }), i2;
  };
  var Gt = function(t2) {
    return t2 instanceof zt ? t2 : new zt(t2);
  };
  var $t = function(t2) {
    return t2 instanceof zt ? t2.values : t2;
  };
  var Xt = class {
    static groupObjects() {
      let t2, e2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : [], { depth: i2, asTree: n2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
      n2 && null == i2 && (i2 = 0);
      const r2 = [];
      return Array.from(e2).forEach((e3) => {
        var o2;
        if (t2) {
          var s2, a2, l2;
          if (null !== (s2 = e3.canBeGrouped) && void 0 !== s2 && s2.call(e3, i2) && null !== (a2 = (l2 = t2[t2.length - 1]).canBeGroupedWith) && void 0 !== a2 && a2.call(l2, e3, i2))
            return void t2.push(e3);
          r2.push(new this(t2, { depth: i2, asTree: n2 })), t2 = null;
        }
        null !== (o2 = e3.canBeGrouped) && void 0 !== o2 && o2.call(e3, i2) ? t2 = [e3] : r2.push(e3);
      }), t2 && r2.push(new this(t2, { depth: i2, asTree: n2 })), r2;
    }
    constructor() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : [], { depth: e2, asTree: i2 } = arguments.length > 1 ? arguments[1] : void 0;
      this.objects = t2, i2 && (this.depth = e2, this.objects = this.constructor.groupObjects(this.objects, { asTree: i2, depth: this.depth + 1 }));
    }
    getObjects() {
      return this.objects;
    }
    getDepth() {
      return this.depth;
    }
    getCacheKey() {
      const t2 = ["objectGroup"];
      return Array.from(this.getObjects()).forEach((e2) => {
        t2.push(e2.getCacheKey());
      }), t2.join("/");
    }
  };
  var Yt = class extends H {
    constructor() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : [];
      super(...arguments), this.objects = {}, Array.from(t2).forEach((t3) => {
        const e2 = JSON.stringify(t3);
        null == this.objects[e2] && (this.objects[e2] = t3);
      });
    }
    find(t2) {
      const e2 = JSON.stringify(t2);
      return this.objects[e2];
    }
  };
  var Qt = class {
    constructor(t2) {
      this.reset(t2);
    }
    add(t2) {
      const e2 = Zt(t2);
      this.elements[e2] = t2;
    }
    remove(t2) {
      const e2 = Zt(t2), i2 = this.elements[e2];
      if (i2)
        return delete this.elements[e2], i2;
    }
    reset() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : [];
      return this.elements = {}, Array.from(t2).forEach((t3) => {
        this.add(t3);
      }), t2;
    }
  };
  var Zt = (t2) => t2.dataset.trixStoreKey;
  var te = class extends H {
    isPerforming() {
      return true === this.performing;
    }
    hasPerformed() {
      return true === this.performed;
    }
    hasSucceeded() {
      return this.performed && this.succeeded;
    }
    hasFailed() {
      return this.performed && !this.succeeded;
    }
    getPromise() {
      return this.promise || (this.promise = new Promise((t2, e2) => (this.performing = true, this.perform((i2, n2) => {
        this.succeeded = i2, this.performing = false, this.performed = true, this.succeeded ? t2(n2) : e2(n2);
      })))), this.promise;
    }
    perform(t2) {
      return t2(false);
    }
    release() {
      var t2, e2;
      null === (t2 = this.promise) || void 0 === t2 || null === (e2 = t2.cancel) || void 0 === e2 || e2.call(t2), this.promise = null, this.performing = null, this.performed = null, this.succeeded = null;
    }
  };
  te.proxyMethod("getPromise().then"), te.proxyMethod("getPromise().catch");
  var ee = class extends H {
    constructor(t2) {
      let e2 = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
      super(...arguments), this.object = t2, this.options = e2, this.childViews = [], this.rootView = this;
    }
    getNodes() {
      return this.nodes || (this.nodes = this.createNodes()), this.nodes.map((t2) => t2.cloneNode(true));
    }
    invalidate() {
      var t2;
      return this.nodes = null, this.childViews = [], null === (t2 = this.parentView) || void 0 === t2 ? void 0 : t2.invalidate();
    }
    invalidateViewForObject(t2) {
      var e2;
      return null === (e2 = this.findViewForObject(t2)) || void 0 === e2 ? void 0 : e2.invalidate();
    }
    findOrCreateCachedChildView(t2, e2, i2) {
      let n2 = this.getCachedViewForObject(e2);
      return n2 ? this.recordChildView(n2) : (n2 = this.createChildView(...arguments), this.cacheViewForObject(n2, e2)), n2;
    }
    createChildView(t2, e2) {
      let i2 = arguments.length > 2 && void 0 !== arguments[2] ? arguments[2] : {};
      e2 instanceof Xt && (i2.viewClass = t2, t2 = ie);
      const n2 = new t2(e2, i2);
      return this.recordChildView(n2);
    }
    recordChildView(t2) {
      return t2.parentView = this, t2.rootView = this.rootView, this.childViews.push(t2), t2;
    }
    getAllChildViews() {
      let t2 = [];
      return this.childViews.forEach((e2) => {
        t2.push(e2), t2 = t2.concat(e2.getAllChildViews());
      }), t2;
    }
    findElement() {
      return this.findElementForObject(this.object);
    }
    findElementForObject(t2) {
      const e2 = null == t2 ? void 0 : t2.id;
      if (e2)
        return this.rootView.element.querySelector("[data-trix-id='".concat(e2, "']"));
    }
    findViewForObject(t2) {
      for (const e2 of this.getAllChildViews())
        if (e2.object === t2)
          return e2;
    }
    getViewCache() {
      return this.rootView !== this ? this.rootView.getViewCache() : this.isViewCachingEnabled() ? (this.viewCache || (this.viewCache = {}), this.viewCache) : void 0;
    }
    isViewCachingEnabled() {
      return false !== this.shouldCacheViews;
    }
    enableViewCaching() {
      this.shouldCacheViews = true;
    }
    disableViewCaching() {
      this.shouldCacheViews = false;
    }
    getCachedViewForObject(t2) {
      var e2;
      return null === (e2 = this.getViewCache()) || void 0 === e2 ? void 0 : e2[t2.getCacheKey()];
    }
    cacheViewForObject(t2, e2) {
      const i2 = this.getViewCache();
      i2 && (i2[e2.getCacheKey()] = t2);
    }
    garbageCollectCachedViews() {
      const t2 = this.getViewCache();
      if (t2) {
        const e2 = this.getAllChildViews().concat(this).map((t3) => t3.object.getCacheKey());
        for (const i2 in t2)
          e2.includes(i2) || delete t2[i2];
      }
    }
  };
  var ie = class extends ee {
    constructor() {
      super(...arguments), this.objectGroup = this.object, this.viewClass = this.options.viewClass, delete this.options.viewClass;
    }
    getChildViews() {
      return this.childViews.length || Array.from(this.objectGroup.getObjects()).forEach((t2) => {
        this.findOrCreateCachedChildView(this.viewClass, t2, this.options);
      }), this.childViews;
    }
    createNodes() {
      const t2 = this.createContainerElement();
      return this.getChildViews().forEach((e2) => {
        Array.from(e2.getNodes()).forEach((e3) => {
          t2.appendChild(e3);
        });
      }), [t2];
    }
    createContainerElement() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : this.objectGroup.getDepth();
      return this.getChildViews()[0].createContainerElement(t2);
    }
  };
  var ne = "style href src width height language class".split(" ");
  var re = "javascript:".split(" ");
  var oe = "script iframe form noscript".split(" ");
  var se = class extends H {
    static setHTML(t2, e2) {
      const i2 = new this(e2).sanitize(), n2 = i2.getHTML ? i2.getHTML() : i2.outerHTML;
      t2.innerHTML = n2;
    }
    static sanitize(t2, e2) {
      const i2 = new this(t2, e2);
      return i2.sanitize(), i2;
    }
    constructor(t2) {
      let { allowedAttributes: e2, forbiddenProtocols: i2, forbiddenElements: n2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
      super(...arguments), this.allowedAttributes = e2 || ne, this.forbiddenProtocols = i2 || re, this.forbiddenElements = n2 || oe, this.body = ae(t2);
    }
    sanitize() {
      return this.sanitizeElements(), this.normalizeListElementNesting();
    }
    getHTML() {
      return this.body.innerHTML;
    }
    getBody() {
      return this.body;
    }
    sanitizeElements() {
      const t2 = R(this.body), e2 = [];
      for (; t2.nextNode(); ) {
        const i2 = t2.currentNode;
        switch (i2.nodeType) {
          case Node.ELEMENT_NODE:
            this.elementIsRemovable(i2) ? e2.push(i2) : this.sanitizeElement(i2);
            break;
          case Node.COMMENT_NODE:
            e2.push(i2);
        }
      }
      return e2.forEach((t3) => k(t3)), this.body;
    }
    sanitizeElement(t2) {
      return t2.hasAttribute("href") && this.forbiddenProtocols.includes(t2.protocol) && t2.removeAttribute("href"), Array.from(t2.attributes).forEach((e2) => {
        let { name: i2 } = e2;
        this.allowedAttributes.includes(i2) || 0 === i2.indexOf("data-trix") || t2.removeAttribute(i2);
      }), t2;
    }
    normalizeListElementNesting() {
      return Array.from(this.body.querySelectorAll("ul,ol")).forEach((t2) => {
        const e2 = t2.previousElementSibling;
        e2 && "li" === E(e2) && e2.appendChild(t2);
      }), this.body;
    }
    elementIsRemovable(t2) {
      if ((null == t2 ? void 0 : t2.nodeType) === Node.ELEMENT_NODE)
        return this.elementIsForbidden(t2) || this.elementIsntSerializable(t2);
    }
    elementIsForbidden(t2) {
      return this.forbiddenElements.includes(E(t2));
    }
    elementIsntSerializable(t2) {
      return "false" === t2.getAttribute("data-trix-serialize") && !I(t2);
    }
  };
  var ae = function() {
    let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : "";
    t2 = t2.replace(/<\/html[^>]*>[^]*$/i, "</html>");
    const e2 = document.implementation.createHTMLDocument("");
    return e2.documentElement.innerHTML = t2, Array.from(e2.head.querySelectorAll("style")).forEach((t3) => {
      e2.body.appendChild(t3);
    }), e2.body;
  };
  var { css: le } = V;
  var ce = class extends ee {
    constructor() {
      super(...arguments), this.attachment = this.object, this.attachment.uploadProgressDelegate = this, this.attachmentPiece = this.options.piece;
    }
    createContentNodes() {
      return [];
    }
    createNodes() {
      let t2;
      const e2 = t2 = S({ tagName: "figure", className: this.getClassName(), data: this.getData(), editable: false }), i2 = this.getHref();
      return i2 && (t2 = S({ tagName: "a", editable: false, attributes: { href: i2, tabindex: -1 } }), e2.appendChild(t2)), this.attachment.hasContent() ? se.setHTML(t2, this.attachment.getContent()) : this.createContentNodes().forEach((e3) => {
        t2.appendChild(e3);
      }), t2.appendChild(this.createCaptionElement()), this.attachment.isPending() && (this.progressElement = S({ tagName: "progress", attributes: { class: le.attachmentProgress, value: this.attachment.getUploadProgress(), max: 100 }, data: { trixMutable: true, trixStoreKey: ["progressElement", this.attachment.id].join("/") } }), e2.appendChild(this.progressElement)), [ue("left"), e2, ue("right")];
    }
    createCaptionElement() {
      const t2 = S({ tagName: "figcaption", className: le.attachmentCaption }), e2 = this.attachmentPiece.getCaption();
      if (e2)
        t2.classList.add("".concat(le.attachmentCaption, "--edited")), t2.textContent = e2;
      else {
        let e3, i2;
        const n2 = this.getCaptionConfig();
        if (n2.name && (e3 = this.attachment.getFilename()), n2.size && (i2 = this.attachment.getFormattedFilesize()), e3) {
          const i3 = S({ tagName: "span", className: le.attachmentName, textContent: e3 });
          t2.appendChild(i3);
        }
        if (i2) {
          e3 && t2.appendChild(document.createTextNode(" "));
          const n3 = S({ tagName: "span", className: le.attachmentSize, textContent: i2 });
          t2.appendChild(n3);
        }
      }
      return t2;
    }
    getClassName() {
      const t2 = [le.attachment, "".concat(le.attachment, "--").concat(this.attachment.getType())], e2 = this.attachment.getExtension();
      return e2 && t2.push("".concat(le.attachment, "--").concat(e2)), t2.join(" ");
    }
    getData() {
      const t2 = { trixAttachment: JSON.stringify(this.attachment), trixContentType: this.attachment.getContentType(), trixId: this.attachment.id }, { attributes: e2 } = this.attachmentPiece;
      return e2.isEmpty() || (t2.trixAttributes = JSON.stringify(e2)), this.attachment.isPending() && (t2.trixSerialize = false), t2;
    }
    getHref() {
      if (!he(this.attachment.getContent(), "a"))
        return this.attachment.getHref();
    }
    getCaptionConfig() {
      var t2;
      const e2 = this.attachment.getType(), n2 = Et(null === (t2 = i[e2]) || void 0 === t2 ? void 0 : t2.caption);
      return "file" === e2 && (n2.name = true), n2;
    }
    findProgressElement() {
      var t2;
      return null === (t2 = this.findElement()) || void 0 === t2 ? void 0 : t2.querySelector("progress");
    }
    attachmentDidChangeUploadProgress() {
      const t2 = this.attachment.getUploadProgress(), e2 = this.findProgressElement();
      e2 && (e2.value = t2);
    }
  };
  var ue = (t2) => S({ tagName: "span", textContent: h, data: { trixCursorTarget: t2, trixSerialize: false } });
  var he = function(t2, e2) {
    const i2 = S("div");
    return se.setHTML(i2, t2 || ""), i2.querySelector(e2);
  };
  var de = class extends ce {
    constructor() {
      super(...arguments), this.attachment.previewDelegate = this;
    }
    createContentNodes() {
      return this.image = S({ tagName: "img", attributes: { src: "" }, data: { trixMutable: true } }), this.refresh(this.image), [this.image];
    }
    createCaptionElement() {
      const t2 = super.createCaptionElement(...arguments);
      return t2.textContent || t2.setAttribute("data-trix-placeholder", l.captionPlaceholder), t2;
    }
    refresh(t2) {
      var e2;
      t2 || (t2 = null === (e2 = this.findElement()) || void 0 === e2 ? void 0 : e2.querySelector("img"));
      if (t2)
        return this.updateAttributesForImage(t2);
    }
    updateAttributesForImage(t2) {
      const e2 = this.attachment.getURL(), i2 = this.attachment.getPreviewURL();
      if (t2.src = i2 || e2, i2 === e2)
        t2.removeAttribute("data-trix-serialized-attributes");
      else {
        const i3 = JSON.stringify({ src: e2 });
        t2.setAttribute("data-trix-serialized-attributes", i3);
      }
      const n2 = this.attachment.getWidth(), r2 = this.attachment.getHeight();
      null != n2 && (t2.width = n2), null != r2 && (t2.height = r2);
      const o2 = ["imageElement", this.attachment.id, t2.src, t2.width, t2.height].join("/");
      t2.dataset.trixStoreKey = o2;
    }
    attachmentDidChangeAttributes() {
      return this.refresh(this.image), this.refresh();
    }
  };
  var ge = class extends ee {
    constructor() {
      super(...arguments), this.piece = this.object, this.attributes = this.piece.getAttributes(), this.textConfig = this.options.textConfig, this.context = this.options.context, this.piece.attachment ? this.attachment = this.piece.attachment : this.string = this.piece.toString();
    }
    createNodes() {
      let t2 = this.attachment ? this.createAttachmentNodes() : this.createStringNodes();
      const e2 = this.createElement();
      if (e2) {
        const i2 = function(t3) {
          for (; null !== (e3 = t3) && void 0 !== e3 && e3.firstElementChild; ) {
            var e3;
            t3 = t3.firstElementChild;
          }
          return t3;
        }(e2);
        Array.from(t2).forEach((t3) => {
          i2.appendChild(t3);
        }), t2 = [e2];
      }
      return t2;
    }
    createAttachmentNodes() {
      const t2 = this.attachment.isPreviewable() ? de : ce;
      return this.createChildView(t2, this.piece.attachment, { piece: this.piece }).getNodes();
    }
    createStringNodes() {
      var t2;
      if (null !== (t2 = this.textConfig) && void 0 !== t2 && t2.plaintext)
        return [document.createTextNode(this.string)];
      {
        const t3 = [], e2 = this.string.split("\n");
        for (let i2 = 0; i2 < e2.length; i2++) {
          const n2 = e2[i2];
          if (i2 > 0) {
            const e3 = S("br");
            t3.push(e3);
          }
          if (n2.length) {
            const e3 = document.createTextNode(this.preserveSpaces(n2));
            t3.push(e3);
          }
        }
        return t3;
      }
    }
    createElement() {
      let t2, e2, i2;
      const n2 = {};
      for (e2 in this.attributes) {
        i2 = this.attributes[e2];
        const o2 = pt(e2);
        if (o2) {
          if (o2.tagName) {
            var r2;
            const e3 = S(o2.tagName);
            r2 ? (r2.appendChild(e3), r2 = e3) : t2 = r2 = e3;
          }
          if (o2.styleProperty && (n2[o2.styleProperty] = i2), o2.style)
            for (e2 in o2.style)
              i2 = o2.style[e2], n2[e2] = i2;
        }
      }
      if (Object.keys(n2).length)
        for (e2 in t2 || (t2 = S("span")), n2)
          i2 = n2[e2], t2.style[e2] = i2;
      return t2;
    }
    createContainerElement() {
      for (const t2 in this.attributes) {
        const e2 = this.attributes[t2], i2 = pt(t2);
        if (i2 && i2.groupTagName) {
          const n2 = {};
          return n2[t2] = e2, S(i2.groupTagName, n2);
        }
      }
    }
    preserveSpaces(t2) {
      return this.context.isLast && (t2 = t2.replace(/\ $/, d)), t2 = t2.replace(/(\S)\ {3}(\S)/g, "$1 ".concat(d, " $2")).replace(/\ {2}/g, "".concat(d, " ")).replace(/\ {2}/g, " ".concat(d)), (this.context.isFirst || this.context.followsWhitespace) && (t2 = t2.replace(/^\ /, d)), t2;
    }
  };
  var me = class extends ee {
    constructor() {
      super(...arguments), this.text = this.object, this.textConfig = this.options.textConfig;
    }
    createNodes() {
      const t2 = [], e2 = Xt.groupObjects(this.getPieces()), i2 = e2.length - 1;
      for (let r2 = 0; r2 < e2.length; r2++) {
        const o2 = e2[r2], s2 = {};
        0 === r2 && (s2.isFirst = true), r2 === i2 && (s2.isLast = true), pe(n2) && (s2.followsWhitespace = true);
        const a2 = this.findOrCreateCachedChildView(ge, o2, { textConfig: this.textConfig, context: s2 });
        t2.push(...Array.from(a2.getNodes() || []));
        var n2 = o2;
      }
      return t2;
    }
    getPieces() {
      return Array.from(this.text.getPieces()).filter((t2) => !t2.hasAttribute("blockBreak"));
    }
  };
  var pe = (t2) => /\s$/.test(null == t2 ? void 0 : t2.toString());
  var { css: fe } = V;
  var be = class extends ee {
    constructor() {
      super(...arguments), this.block = this.object, this.attributes = this.block.getAttributes();
    }
    createNodes() {
      const t2 = [document.createComment("block")];
      if (this.block.isEmpty())
        t2.push(S("br"));
      else {
        var e2;
        const i2 = null === (e2 = gt(this.block.getLastAttribute())) || void 0 === e2 ? void 0 : e2.text, n2 = this.findOrCreateCachedChildView(me, this.block.text, { textConfig: i2 });
        t2.push(...Array.from(n2.getNodes() || [])), this.shouldAddExtraNewlineElement() && t2.push(S("br"));
      }
      if (this.attributes.length)
        return t2;
      {
        let e3;
        const { tagName: i2 } = n.default;
        this.block.isRTL() && (e3 = { dir: "rtl" });
        const r2 = S({ tagName: i2, attributes: e3 });
        return t2.forEach((t3) => r2.appendChild(t3)), [r2];
      }
    }
    createContainerElement(t2) {
      const e2 = {};
      let i2;
      const n2 = this.attributes[t2], { tagName: r2, htmlAttributes: o2 = [] } = gt(n2);
      if (0 === t2 && this.block.isRTL() && Object.assign(e2, { dir: "rtl" }), "attachmentGallery" === n2) {
        const t3 = this.block.getBlockBreakPosition();
        i2 = "".concat(fe.attachmentGallery, " ").concat(fe.attachmentGallery, "--").concat(t3);
      }
      return Object.entries(this.block.htmlAttributes).forEach((t3) => {
        let [i3, n3] = t3;
        o2.includes(i3) && (e2[i3] = n3);
      }), S({ tagName: r2, className: i2, attributes: e2 });
    }
    shouldAddExtraNewlineElement() {
      return /\n\n$/.test(this.block.toString());
    }
  };
  var ve = class extends ee {
    static render(t2) {
      const e2 = S("div"), i2 = new this(t2, { element: e2 });
      return i2.render(), i2.sync(), e2;
    }
    constructor() {
      super(...arguments), this.element = this.options.element, this.elementStore = new Qt(), this.setDocument(this.object);
    }
    setDocument(t2) {
      t2.isEqualTo(this.document) || (this.document = this.object = t2);
    }
    render() {
      if (this.childViews = [], this.shadowElement = S("div"), !this.document.isEmpty()) {
        const t2 = Xt.groupObjects(this.document.getBlocks(), { asTree: true });
        Array.from(t2).forEach((t3) => {
          const e2 = this.findOrCreateCachedChildView(be, t3);
          Array.from(e2.getNodes()).map((t4) => this.shadowElement.appendChild(t4));
        });
      }
    }
    isSynced() {
      return xe(this.shadowElement, this.element);
    }
    sync() {
      const t2 = this.createDocumentFragmentForSync();
      for (; this.element.lastChild; )
        this.element.removeChild(this.element.lastChild);
      return this.element.appendChild(t2), this.didSync();
    }
    didSync() {
      return this.elementStore.reset(Ae(this.element)), Rt(() => this.garbageCollectCachedViews());
    }
    createDocumentFragmentForSync() {
      const t2 = document.createDocumentFragment();
      return Array.from(this.shadowElement.childNodes).forEach((e2) => {
        t2.appendChild(e2.cloneNode(true));
      }), Array.from(Ae(t2)).forEach((t3) => {
        const e2 = this.elementStore.remove(t3);
        e2 && t3.parentNode.replaceChild(e2, t3);
      }), t2;
    }
  };
  var Ae = (t2) => t2.querySelectorAll("[data-trix-store-key]");
  var xe = (t2, e2) => ye(t2.innerHTML) === ye(e2.innerHTML);
  var ye = (t2) => t2.replace(/&nbsp;/g, " ");
  function Ce(t2) {
    var e2, i2;
    function n2(e3, i3) {
      try {
        var o2 = t2[e3](i3), s2 = o2.value, a2 = s2 instanceof ke;
        Promise.resolve(a2 ? s2.v : s2).then(function(i4) {
          if (a2) {
            var l2 = "return" === e3 ? "return" : "next";
            if (!s2.k || i4.done)
              return n2(l2, i4);
            i4 = t2[l2](i4).value;
          }
          r2(o2.done ? "return" : "normal", i4);
        }, function(t3) {
          n2("throw", t3);
        });
      } catch (t3) {
        r2("throw", t3);
      }
    }
    function r2(t3, r3) {
      switch (t3) {
        case "return":
          e2.resolve({ value: r3, done: true });
          break;
        case "throw":
          e2.reject(r3);
          break;
        default:
          e2.resolve({ value: r3, done: false });
      }
      (e2 = e2.next) ? n2(e2.key, e2.arg) : i2 = null;
    }
    this._invoke = function(t3, r3) {
      return new Promise(function(o2, s2) {
        var a2 = { key: t3, arg: r3, resolve: o2, reject: s2, next: null };
        i2 ? i2 = i2.next = a2 : (e2 = i2 = a2, n2(t3, r3));
      });
    }, "function" != typeof t2.return && (this.return = void 0);
  }
  function ke(t2, e2) {
    this.v = t2, this.k = e2;
  }
  function Re(t2, e2, i2) {
    return (e2 = Ee(e2)) in t2 ? Object.defineProperty(t2, e2, { value: i2, enumerable: true, configurable: true, writable: true }) : t2[e2] = i2, t2;
  }
  function Ee(t2) {
    var e2 = function(t3, e3) {
      if ("object" != typeof t3 || null === t3)
        return t3;
      var i2 = t3[Symbol.toPrimitive];
      if (void 0 !== i2) {
        var n2 = i2.call(t3, e3 || "default");
        if ("object" != typeof n2)
          return n2;
        throw new TypeError("@@toPrimitive must return a primitive value.");
      }
      return ("string" === e3 ? String : Number)(t3);
    }(t2, "string");
    return "symbol" == typeof e2 ? e2 : String(e2);
  }
  Ce.prototype["function" == typeof Symbol && Symbol.asyncIterator || "@@asyncIterator"] = function() {
    return this;
  }, Ce.prototype.next = function(t2) {
    return this._invoke("next", t2);
  }, Ce.prototype.throw = function(t2) {
    return this._invoke("throw", t2);
  }, Ce.prototype.return = function(t2) {
    return this._invoke("return", t2);
  };
  var Se = class extends nt {
    static registerType(t2, e2) {
      e2.type = t2, this.types[t2] = e2;
    }
    static fromJSON(t2) {
      const e2 = this.types[t2.type];
      if (e2)
        return e2.fromJSON(t2);
    }
    constructor(t2) {
      let e2 = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
      super(...arguments), this.attributes = zt.box(e2);
    }
    copyWithAttributes(t2) {
      return new this.constructor(this.getValue(), t2);
    }
    copyWithAdditionalAttributes(t2) {
      return this.copyWithAttributes(this.attributes.merge(t2));
    }
    copyWithoutAttribute(t2) {
      return this.copyWithAttributes(this.attributes.remove(t2));
    }
    copy() {
      return this.copyWithAttributes(this.attributes);
    }
    getAttribute(t2) {
      return this.attributes.get(t2);
    }
    getAttributesHash() {
      return this.attributes;
    }
    getAttributes() {
      return this.attributes.toObject();
    }
    hasAttribute(t2) {
      return this.attributes.has(t2);
    }
    hasSameStringValueAsPiece(t2) {
      return t2 && this.toString() === t2.toString();
    }
    hasSameAttributesAsPiece(t2) {
      return t2 && (this.attributes === t2.attributes || this.attributes.isEqualTo(t2.attributes));
    }
    isBlockBreak() {
      return false;
    }
    isEqualTo(t2) {
      return super.isEqualTo(...arguments) || this.hasSameConstructorAs(t2) && this.hasSameStringValueAsPiece(t2) && this.hasSameAttributesAsPiece(t2);
    }
    isEmpty() {
      return 0 === this.length;
    }
    isSerializable() {
      return true;
    }
    toJSON() {
      return { type: this.constructor.type, attributes: this.getAttributes() };
    }
    contentsForInspection() {
      return { type: this.constructor.type, attributes: this.attributes.inspect() };
    }
    canBeGrouped() {
      return this.hasAttribute("href");
    }
    canBeGroupedWith(t2) {
      return this.getAttribute("href") === t2.getAttribute("href");
    }
    getLength() {
      return this.length;
    }
    canBeConsolidatedWith(t2) {
      return false;
    }
  };
  Re(Se, "types", {});
  var Le = class extends te {
    constructor(t2) {
      super(...arguments), this.url = t2;
    }
    perform(t2) {
      const e2 = new Image();
      e2.onload = () => (e2.width = this.width = e2.naturalWidth, e2.height = this.height = e2.naturalHeight, t2(true, e2)), e2.onerror = () => t2(false), e2.src = this.url;
    }
  };
  var De = class extends nt {
    static attachmentForFile(t2) {
      const e2 = new this(this.attributesForFile(t2));
      return e2.setFile(t2), e2;
    }
    static attributesForFile(t2) {
      return new zt({ filename: t2.name, filesize: t2.size, contentType: t2.type });
    }
    static fromJSON(t2) {
      return new this(t2);
    }
    constructor() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {};
      super(t2), this.releaseFile = this.releaseFile.bind(this), this.attributes = zt.box(t2), this.didChangeAttributes();
    }
    getAttribute(t2) {
      return this.attributes.get(t2);
    }
    hasAttribute(t2) {
      return this.attributes.has(t2);
    }
    getAttributes() {
      return this.attributes.toObject();
    }
    setAttributes() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {};
      const e2 = this.attributes.merge(t2);
      var i2, n2, r2, o2;
      if (!this.attributes.isEqualTo(e2))
        return this.attributes = e2, this.didChangeAttributes(), null === (i2 = this.previewDelegate) || void 0 === i2 || null === (n2 = i2.attachmentDidChangeAttributes) || void 0 === n2 || n2.call(i2, this), null === (r2 = this.delegate) || void 0 === r2 || null === (o2 = r2.attachmentDidChangeAttributes) || void 0 === o2 ? void 0 : o2.call(r2, this);
    }
    didChangeAttributes() {
      if (this.isPreviewable())
        return this.preloadURL();
    }
    isPending() {
      return null != this.file && !(this.getURL() || this.getHref());
    }
    isPreviewable() {
      return this.attributes.has("previewable") ? this.attributes.get("previewable") : De.previewablePattern.test(this.getContentType());
    }
    getType() {
      return this.hasContent() ? "content" : this.isPreviewable() ? "preview" : "file";
    }
    getURL() {
      return this.attributes.get("url");
    }
    getHref() {
      return this.attributes.get("href");
    }
    getFilename() {
      return this.attributes.get("filename") || "";
    }
    getFilesize() {
      return this.attributes.get("filesize");
    }
    getFormattedFilesize() {
      const t2 = this.attributes.get("filesize");
      return "number" == typeof t2 ? u.formatter(t2) : "";
    }
    getExtension() {
      var t2;
      return null === (t2 = this.getFilename().match(/\.(\w+)$/)) || void 0 === t2 ? void 0 : t2[1].toLowerCase();
    }
    getContentType() {
      return this.attributes.get("contentType");
    }
    hasContent() {
      return this.attributes.has("content");
    }
    getContent() {
      return this.attributes.get("content");
    }
    getWidth() {
      return this.attributes.get("width");
    }
    getHeight() {
      return this.attributes.get("height");
    }
    getFile() {
      return this.file;
    }
    setFile(t2) {
      if (this.file = t2, this.isPreviewable())
        return this.preloadFile();
    }
    releaseFile() {
      this.releasePreloadedFile(), this.file = null;
    }
    getUploadProgress() {
      return null != this.uploadProgress ? this.uploadProgress : 0;
    }
    setUploadProgress(t2) {
      var e2, i2;
      if (this.uploadProgress !== t2)
        return this.uploadProgress = t2, null === (e2 = this.uploadProgressDelegate) || void 0 === e2 || null === (i2 = e2.attachmentDidChangeUploadProgress) || void 0 === i2 ? void 0 : i2.call(e2, this);
    }
    toJSON() {
      return this.getAttributes();
    }
    getCacheKey() {
      return [super.getCacheKey(...arguments), this.attributes.getCacheKey(), this.getPreviewURL()].join("/");
    }
    getPreviewURL() {
      return this.previewURL || this.preloadingURL;
    }
    setPreviewURL(t2) {
      var e2, i2, n2, r2;
      if (t2 !== this.getPreviewURL())
        return this.previewURL = t2, null === (e2 = this.previewDelegate) || void 0 === e2 || null === (i2 = e2.attachmentDidChangeAttributes) || void 0 === i2 || i2.call(e2, this), null === (n2 = this.delegate) || void 0 === n2 || null === (r2 = n2.attachmentDidChangePreviewURL) || void 0 === r2 ? void 0 : r2.call(n2, this);
    }
    preloadURL() {
      return this.preload(this.getURL(), this.releaseFile);
    }
    preloadFile() {
      if (this.file)
        return this.fileObjectURL = URL.createObjectURL(this.file), this.preload(this.fileObjectURL);
    }
    releasePreloadedFile() {
      this.fileObjectURL && (URL.revokeObjectURL(this.fileObjectURL), this.fileObjectURL = null);
    }
    preload(t2, e2) {
      if (t2 && t2 !== this.getPreviewURL()) {
        this.preloadingURL = t2;
        return new Le(t2).then((i2) => {
          let { width: n2, height: r2 } = i2;
          return this.getWidth() && this.getHeight() || this.setAttributes({ width: n2, height: r2 }), this.preloadingURL = null, this.setPreviewURL(t2), null == e2 ? void 0 : e2();
        }).catch(() => (this.preloadingURL = null, null == e2 ? void 0 : e2()));
      }
    }
  };
  Re(De, "previewablePattern", /^image(\/(gif|png|webp|jpe?g)|$)/);
  var we = class extends Se {
    static fromJSON(t2) {
      return new this(De.fromJSON(t2.attachment), t2.attributes);
    }
    constructor(t2) {
      super(...arguments), this.attachment = t2, this.length = 1, this.ensureAttachmentExclusivelyHasAttribute("href"), this.attachment.hasContent() || this.removeProhibitedAttributes();
    }
    ensureAttachmentExclusivelyHasAttribute(t2) {
      this.hasAttribute(t2) && (this.attachment.hasAttribute(t2) || this.attachment.setAttributes(this.attributes.slice([t2])), this.attributes = this.attributes.remove(t2));
    }
    removeProhibitedAttributes() {
      const t2 = this.attributes.slice(we.permittedAttributes);
      t2.isEqualTo(this.attributes) || (this.attributes = t2);
    }
    getValue() {
      return this.attachment;
    }
    isSerializable() {
      return !this.attachment.isPending();
    }
    getCaption() {
      return this.attributes.get("caption") || "";
    }
    isEqualTo(t2) {
      var e2;
      return super.isEqualTo(t2) && this.attachment.id === (null == t2 || null === (e2 = t2.attachment) || void 0 === e2 ? void 0 : e2.id);
    }
    toString() {
      return "\uFFFC";
    }
    toJSON() {
      const t2 = super.toJSON(...arguments);
      return t2.attachment = this.attachment, t2;
    }
    getCacheKey() {
      return [super.getCacheKey(...arguments), this.attachment.getCacheKey()].join("/");
    }
    toConsole() {
      return JSON.stringify(this.toString());
    }
  };
  Re(we, "permittedAttributes", ["caption", "presentation"]), Se.registerType("attachment", we);
  var Te = class extends Se {
    static fromJSON(t2) {
      return new this(t2.string, t2.attributes);
    }
    constructor(t2) {
      super(...arguments), this.string = ((t3) => t3.replace(/\r\n?/g, "\n"))(t2), this.length = this.string.length;
    }
    getValue() {
      return this.string;
    }
    toString() {
      return this.string.toString();
    }
    isBlockBreak() {
      return "\n" === this.toString() && true === this.getAttribute("blockBreak");
    }
    toJSON() {
      const t2 = super.toJSON(...arguments);
      return t2.string = this.string, t2;
    }
    canBeConsolidatedWith(t2) {
      return t2 && this.hasSameConstructorAs(t2) && this.hasSameAttributesAsPiece(t2);
    }
    consolidateWith(t2) {
      return new this.constructor(this.toString() + t2.toString(), this.attributes);
    }
    splitAtOffset(t2) {
      let e2, i2;
      return 0 === t2 ? (e2 = null, i2 = this) : t2 === this.length ? (e2 = this, i2 = null) : (e2 = new this.constructor(this.string.slice(0, t2), this.attributes), i2 = new this.constructor(this.string.slice(t2), this.attributes)), [e2, i2];
    }
    toConsole() {
      let { string: t2 } = this;
      return t2.length > 15 && (t2 = t2.slice(0, 14) + "\u2026"), JSON.stringify(t2.toString());
    }
  };
  Se.registerType("string", Te);
  var Be = class extends nt {
    static box(t2) {
      return t2 instanceof this ? t2 : new this(t2);
    }
    constructor() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : [];
      super(...arguments), this.objects = t2.slice(0), this.length = this.objects.length;
    }
    indexOf(t2) {
      return this.objects.indexOf(t2);
    }
    splice() {
      for (var t2 = arguments.length, e2 = new Array(t2), i2 = 0; i2 < t2; i2++)
        e2[i2] = arguments[i2];
      return new this.constructor(ot(this.objects, ...e2));
    }
    eachObject(t2) {
      return this.objects.map((e2, i2) => t2(e2, i2));
    }
    insertObjectAtIndex(t2, e2) {
      return this.splice(e2, 0, t2);
    }
    insertSplittableListAtIndex(t2, e2) {
      return this.splice(e2, 0, ...t2.objects);
    }
    insertSplittableListAtPosition(t2, e2) {
      const [i2, n2] = this.splitObjectAtPosition(e2);
      return new this.constructor(i2).insertSplittableListAtIndex(t2, n2);
    }
    editObjectAtIndex(t2, e2) {
      return this.replaceObjectAtIndex(e2(this.objects[t2]), t2);
    }
    replaceObjectAtIndex(t2, e2) {
      return this.splice(e2, 1, t2);
    }
    removeObjectAtIndex(t2) {
      return this.splice(t2, 1);
    }
    getObjectAtIndex(t2) {
      return this.objects[t2];
    }
    getSplittableListInRange(t2) {
      const [e2, i2, n2] = this.splitObjectsAtRange(t2);
      return new this.constructor(e2.slice(i2, n2 + 1));
    }
    selectSplittableList(t2) {
      const e2 = this.objects.filter((e3) => t2(e3));
      return new this.constructor(e2);
    }
    removeObjectsInRange(t2) {
      const [e2, i2, n2] = this.splitObjectsAtRange(t2);
      return new this.constructor(e2).splice(i2, n2 - i2 + 1);
    }
    transformObjectsInRange(t2, e2) {
      const [i2, n2, r2] = this.splitObjectsAtRange(t2), o2 = i2.map((t3, i3) => n2 <= i3 && i3 <= r2 ? e2(t3) : t3);
      return new this.constructor(o2);
    }
    splitObjectsAtRange(t2) {
      let e2, [i2, n2, r2] = this.splitObjectAtPosition(Pe(t2));
      return [i2, e2] = new this.constructor(i2).splitObjectAtPosition(Ie(t2) + r2), [i2, n2, e2 - 1];
    }
    getObjectAtPosition(t2) {
      const { index: e2 } = this.findIndexAndOffsetAtPosition(t2);
      return this.objects[e2];
    }
    splitObjectAtPosition(t2) {
      let e2, i2;
      const { index: n2, offset: r2 } = this.findIndexAndOffsetAtPosition(t2), o2 = this.objects.slice(0);
      if (null != n2)
        if (0 === r2)
          e2 = n2, i2 = 0;
        else {
          const t3 = this.getObjectAtIndex(n2), [s2, a2] = t3.splitAtOffset(r2);
          o2.splice(n2, 1, s2, a2), e2 = n2 + 1, i2 = s2.getLength() - r2;
        }
      else
        e2 = o2.length, i2 = 0;
      return [o2, e2, i2];
    }
    consolidate() {
      const t2 = [];
      let e2 = this.objects[0];
      return this.objects.slice(1).forEach((i2) => {
        var n2, r2;
        null !== (n2 = (r2 = e2).canBeConsolidatedWith) && void 0 !== n2 && n2.call(r2, i2) ? e2 = e2.consolidateWith(i2) : (t2.push(e2), e2 = i2);
      }), e2 && t2.push(e2), new this.constructor(t2);
    }
    consolidateFromIndexToIndex(t2, e2) {
      const i2 = this.objects.slice(0).slice(t2, e2 + 1), n2 = new this.constructor(i2).consolidate().toArray();
      return this.splice(t2, i2.length, ...n2);
    }
    findIndexAndOffsetAtPosition(t2) {
      let e2, i2 = 0;
      for (e2 = 0; e2 < this.objects.length; e2++) {
        const n2 = i2 + this.objects[e2].getLength();
        if (i2 <= t2 && t2 < n2)
          return { index: e2, offset: t2 - i2 };
        i2 = n2;
      }
      return { index: null, offset: null };
    }
    findPositionAtIndexAndOffset(t2, e2) {
      let i2 = 0;
      for (let n2 = 0; n2 < this.objects.length; n2++) {
        const r2 = this.objects[n2];
        if (n2 < t2)
          i2 += r2.getLength();
        else if (n2 === t2) {
          i2 += e2;
          break;
        }
      }
      return i2;
    }
    getEndPosition() {
      return null == this.endPosition && (this.endPosition = 0, this.objects.forEach((t2) => this.endPosition += t2.getLength())), this.endPosition;
    }
    toString() {
      return this.objects.join("");
    }
    toArray() {
      return this.objects.slice(0);
    }
    toJSON() {
      return this.toArray();
    }
    isEqualTo(t2) {
      return super.isEqualTo(...arguments) || Fe(this.objects, null == t2 ? void 0 : t2.objects);
    }
    contentsForInspection() {
      return { objects: "[".concat(this.objects.map((t2) => t2.inspect()).join(", "), "]") };
    }
  };
  var Fe = function(t2) {
    let e2 = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : [];
    if (t2.length !== e2.length)
      return false;
    let i2 = true;
    for (let n2 = 0; n2 < t2.length; n2++) {
      const r2 = t2[n2];
      i2 && !r2.isEqualTo(e2[n2]) && (i2 = false);
    }
    return i2;
  };
  var Pe = (t2) => t2[0];
  var Ie = (t2) => t2[1];
  var Ne = class extends nt {
    static textForAttachmentWithAttributes(t2, e2) {
      return new this([new we(t2, e2)]);
    }
    static textForStringWithAttributes(t2, e2) {
      return new this([new Te(t2, e2)]);
    }
    static fromJSON(t2) {
      return new this(Array.from(t2).map((t3) => Se.fromJSON(t3)));
    }
    constructor() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : [];
      super(...arguments);
      const e2 = t2.filter((t3) => !t3.isEmpty());
      this.pieceList = new Be(e2);
    }
    copy() {
      return this.copyWithPieceList(this.pieceList);
    }
    copyWithPieceList(t2) {
      return new this.constructor(t2.consolidate().toArray());
    }
    copyUsingObjectMap(t2) {
      const e2 = this.getPieces().map((e3) => t2.find(e3) || e3);
      return new this.constructor(e2);
    }
    appendText(t2) {
      return this.insertTextAtPosition(t2, this.getLength());
    }
    insertTextAtPosition(t2, e2) {
      return this.copyWithPieceList(this.pieceList.insertSplittableListAtPosition(t2.pieceList, e2));
    }
    removeTextAtRange(t2) {
      return this.copyWithPieceList(this.pieceList.removeObjectsInRange(t2));
    }
    replaceTextAtRange(t2, e2) {
      return this.removeTextAtRange(e2).insertTextAtPosition(t2, e2[0]);
    }
    moveTextFromRangeToPosition(t2, e2) {
      if (t2[0] <= e2 && e2 <= t2[1])
        return;
      const i2 = this.getTextAtRange(t2), n2 = i2.getLength();
      return t2[0] < e2 && (e2 -= n2), this.removeTextAtRange(t2).insertTextAtPosition(i2, e2);
    }
    addAttributeAtRange(t2, e2, i2) {
      const n2 = {};
      return n2[t2] = e2, this.addAttributesAtRange(n2, i2);
    }
    addAttributesAtRange(t2, e2) {
      return this.copyWithPieceList(this.pieceList.transformObjectsInRange(e2, (e3) => e3.copyWithAdditionalAttributes(t2)));
    }
    removeAttributeAtRange(t2, e2) {
      return this.copyWithPieceList(this.pieceList.transformObjectsInRange(e2, (e3) => e3.copyWithoutAttribute(t2)));
    }
    setAttributesAtRange(t2, e2) {
      return this.copyWithPieceList(this.pieceList.transformObjectsInRange(e2, (e3) => e3.copyWithAttributes(t2)));
    }
    getAttributesAtPosition(t2) {
      var e2;
      return (null === (e2 = this.pieceList.getObjectAtPosition(t2)) || void 0 === e2 ? void 0 : e2.getAttributes()) || {};
    }
    getCommonAttributes() {
      const t2 = Array.from(this.pieceList.toArray()).map((t3) => t3.getAttributes());
      return zt.fromCommonAttributesOfObjects(t2).toObject();
    }
    getCommonAttributesAtRange(t2) {
      return this.getTextAtRange(t2).getCommonAttributes() || {};
    }
    getExpandedRangeForAttributeAtOffset(t2, e2) {
      let i2, n2 = i2 = e2;
      const r2 = this.getLength();
      for (; n2 > 0 && this.getCommonAttributesAtRange([n2 - 1, i2])[t2]; )
        n2--;
      for (; i2 < r2 && this.getCommonAttributesAtRange([e2, i2 + 1])[t2]; )
        i2++;
      return [n2, i2];
    }
    getTextAtRange(t2) {
      return this.copyWithPieceList(this.pieceList.getSplittableListInRange(t2));
    }
    getStringAtRange(t2) {
      return this.pieceList.getSplittableListInRange(t2).toString();
    }
    getStringAtPosition(t2) {
      return this.getStringAtRange([t2, t2 + 1]);
    }
    startsWithString(t2) {
      return this.getStringAtRange([0, t2.length]) === t2;
    }
    endsWithString(t2) {
      const e2 = this.getLength();
      return this.getStringAtRange([e2 - t2.length, e2]) === t2;
    }
    getAttachmentPieces() {
      return this.pieceList.toArray().filter((t2) => !!t2.attachment);
    }
    getAttachments() {
      return this.getAttachmentPieces().map((t2) => t2.attachment);
    }
    getAttachmentAndPositionById(t2) {
      let e2 = 0;
      for (const n2 of this.pieceList.toArray()) {
        var i2;
        if ((null === (i2 = n2.attachment) || void 0 === i2 ? void 0 : i2.id) === t2)
          return { attachment: n2.attachment, position: e2 };
        e2 += n2.length;
      }
      return { attachment: null, position: null };
    }
    getAttachmentById(t2) {
      const { attachment: e2 } = this.getAttachmentAndPositionById(t2);
      return e2;
    }
    getRangeOfAttachment(t2) {
      const e2 = this.getAttachmentAndPositionById(t2.id), i2 = e2.position;
      if (t2 = e2.attachment)
        return [i2, i2 + 1];
    }
    updateAttributesForAttachment(t2, e2) {
      const i2 = this.getRangeOfAttachment(e2);
      return i2 ? this.addAttributesAtRange(t2, i2) : this;
    }
    getLength() {
      return this.pieceList.getEndPosition();
    }
    isEmpty() {
      return 0 === this.getLength();
    }
    isEqualTo(t2) {
      var e2;
      return super.isEqualTo(t2) || (null == t2 || null === (e2 = t2.pieceList) || void 0 === e2 ? void 0 : e2.isEqualTo(this.pieceList));
    }
    isBlockBreak() {
      return 1 === this.getLength() && this.pieceList.getObjectAtIndex(0).isBlockBreak();
    }
    eachPiece(t2) {
      return this.pieceList.eachObject(t2);
    }
    getPieces() {
      return this.pieceList.toArray();
    }
    getPieceAtPosition(t2) {
      return this.pieceList.getObjectAtPosition(t2);
    }
    contentsForInspection() {
      return { pieceList: this.pieceList.inspect() };
    }
    toSerializableText() {
      const t2 = this.pieceList.selectSplittableList((t3) => t3.isSerializable());
      return this.copyWithPieceList(t2);
    }
    toString() {
      return this.pieceList.toString();
    }
    toJSON() {
      return this.pieceList.toJSON();
    }
    toConsole() {
      return JSON.stringify(this.pieceList.toArray().map((t2) => JSON.parse(t2.toConsole())));
    }
    getDirection() {
      return at(this.toString());
    }
    isRTL() {
      return "rtl" === this.getDirection();
    }
  };
  var Oe = class extends nt {
    static fromJSON(t2) {
      return new this(Ne.fromJSON(t2.text), t2.attributes, t2.htmlAttributes);
    }
    constructor(t2, e2, i2) {
      super(...arguments), this.text = Me(t2 || new Ne()), this.attributes = e2 || [], this.htmlAttributes = i2 || {};
    }
    isEmpty() {
      return this.text.isBlockBreak();
    }
    isEqualTo(t2) {
      return !!super.isEqualTo(t2) || this.text.isEqualTo(null == t2 ? void 0 : t2.text) && rt(this.attributes, null == t2 ? void 0 : t2.attributes) && St(this.htmlAttributes, null == t2 ? void 0 : t2.htmlAttributes);
    }
    copyWithText(t2) {
      return new Oe(t2, this.attributes, this.htmlAttributes);
    }
    copyWithoutText() {
      return this.copyWithText(null);
    }
    copyWithAttributes(t2) {
      return new Oe(this.text, t2, this.htmlAttributes);
    }
    copyWithoutAttributes() {
      return this.copyWithAttributes(null);
    }
    copyUsingObjectMap(t2) {
      const e2 = t2.find(this.text);
      return e2 ? this.copyWithText(e2) : this.copyWithText(this.text.copyUsingObjectMap(t2));
    }
    addAttribute(t2) {
      const e2 = this.attributes.concat(He(t2));
      return this.copyWithAttributes(e2);
    }
    addHTMLAttribute(t2, e2) {
      const i2 = Object.assign({}, this.htmlAttributes, { [t2]: e2 });
      return new Oe(this.text, this.attributes, i2);
    }
    removeAttribute(t2) {
      const { listAttribute: e2 } = gt(t2), i2 = _e(_e(this.attributes, t2), e2);
      return this.copyWithAttributes(i2);
    }
    removeLastAttribute() {
      return this.removeAttribute(this.getLastAttribute());
    }
    getLastAttribute() {
      return ze(this.attributes);
    }
    getAttributes() {
      return this.attributes.slice(0);
    }
    getAttributeLevel() {
      return this.attributes.length;
    }
    getAttributeAtLevel(t2) {
      return this.attributes[t2 - 1];
    }
    hasAttribute(t2) {
      return this.attributes.includes(t2);
    }
    hasAttributes() {
      return this.getAttributeLevel() > 0;
    }
    getLastNestableAttribute() {
      return ze(this.getNestableAttributes());
    }
    getNestableAttributes() {
      return this.attributes.filter((t2) => gt(t2).nestable);
    }
    getNestingLevel() {
      return this.getNestableAttributes().length;
    }
    decreaseNestingLevel() {
      const t2 = this.getLastNestableAttribute();
      return t2 ? this.removeAttribute(t2) : this;
    }
    increaseNestingLevel() {
      const t2 = this.getLastNestableAttribute();
      if (t2) {
        const e2 = this.attributes.lastIndexOf(t2), i2 = ot(this.attributes, e2 + 1, 0, ...He(t2));
        return this.copyWithAttributes(i2);
      }
      return this;
    }
    getListItemAttributes() {
      return this.attributes.filter((t2) => gt(t2).listAttribute);
    }
    isListItem() {
      var t2;
      return null === (t2 = gt(this.getLastAttribute())) || void 0 === t2 ? void 0 : t2.listAttribute;
    }
    isTerminalBlock() {
      var t2;
      return null === (t2 = gt(this.getLastAttribute())) || void 0 === t2 ? void 0 : t2.terminal;
    }
    breaksOnReturn() {
      var t2;
      return null === (t2 = gt(this.getLastAttribute())) || void 0 === t2 ? void 0 : t2.breakOnReturn;
    }
    findLineBreakInDirectionFromPosition(t2, e2) {
      const i2 = this.toString();
      let n2;
      switch (t2) {
        case "forward":
          n2 = i2.indexOf("\n", e2);
          break;
        case "backward":
          n2 = i2.slice(0, e2).lastIndexOf("\n");
      }
      if (-1 !== n2)
        return n2;
    }
    contentsForInspection() {
      return { text: this.text.inspect(), attributes: this.attributes };
    }
    toString() {
      return this.text.toString();
    }
    toJSON() {
      return { text: this.text, attributes: this.attributes, htmlAttributes: this.htmlAttributes };
    }
    getDirection() {
      return this.text.getDirection();
    }
    isRTL() {
      return this.text.isRTL();
    }
    getLength() {
      return this.text.getLength();
    }
    canBeConsolidatedWith(t2) {
      return !this.hasAttributes() && !t2.hasAttributes() && this.getDirection() === t2.getDirection();
    }
    consolidateWith(t2) {
      const e2 = Ne.textForStringWithAttributes("\n"), i2 = this.getTextWithoutBlockBreak().appendText(e2);
      return this.copyWithText(i2.appendText(t2.text));
    }
    splitAtOffset(t2) {
      let e2, i2;
      return 0 === t2 ? (e2 = null, i2 = this) : t2 === this.getLength() ? (e2 = this, i2 = null) : (e2 = this.copyWithText(this.text.getTextAtRange([0, t2])), i2 = this.copyWithText(this.text.getTextAtRange([t2, this.getLength()]))), [e2, i2];
    }
    getBlockBreakPosition() {
      return this.text.getLength() - 1;
    }
    getTextWithoutBlockBreak() {
      return qe(this.text) ? this.text.getTextAtRange([0, this.getBlockBreakPosition()]) : this.text.copy();
    }
    canBeGrouped(t2) {
      return this.attributes[t2];
    }
    canBeGroupedWith(t2, e2) {
      const i2 = t2.getAttributes(), r2 = i2[e2], o2 = this.attributes[e2];
      return o2 === r2 && !(false === gt(o2).group && !(() => {
        if (!ht) {
          ht = [];
          for (const t3 in n) {
            const { listAttribute: e3 } = n[t3];
            null != e3 && ht.push(e3);
          }
        }
        return ht;
      })().includes(i2[e2 + 1])) && (this.getDirection() === t2.getDirection() || t2.isEmpty());
    }
  };
  var Me = function(t2) {
    return t2 = je(t2), t2 = Ue(t2);
  };
  var je = function(t2) {
    let e2 = false;
    const i2 = t2.getPieces();
    let n2 = i2.slice(0, i2.length - 1);
    const r2 = i2[i2.length - 1];
    return r2 ? (n2 = n2.map((t3) => t3.isBlockBreak() ? (e2 = true, Ve(t3)) : t3), e2 ? new Ne([...n2, r2]) : t2) : t2;
  };
  var We = Ne.textForStringWithAttributes("\n", { blockBreak: true });
  var Ue = function(t2) {
    return qe(t2) ? t2 : t2.appendText(We);
  };
  var qe = function(t2) {
    const e2 = t2.getLength();
    if (0 === e2)
      return false;
    return t2.getTextAtRange([e2 - 1, e2]).isBlockBreak();
  };
  var Ve = (t2) => t2.copyWithoutAttribute("blockBreak");
  var He = function(t2) {
    const { listAttribute: e2 } = gt(t2);
    return e2 ? [e2, t2] : [t2];
  };
  var ze = (t2) => t2.slice(-1)[0];
  var _e = function(t2, e2) {
    const i2 = t2.lastIndexOf(e2);
    return -1 === i2 ? t2 : ot(t2, i2, 1);
  };
  var Je = class extends nt {
    static fromJSON(t2) {
      return new this(Array.from(t2).map((t3) => Oe.fromJSON(t3)));
    }
    static fromString(t2, e2) {
      const i2 = Ne.textForStringWithAttributes(t2, e2);
      return new this([new Oe(i2)]);
    }
    constructor() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : [];
      super(...arguments), 0 === t2.length && (t2 = [new Oe()]), this.blockList = Be.box(t2);
    }
    isEmpty() {
      const t2 = this.getBlockAtIndex(0);
      return 1 === this.blockList.length && t2.isEmpty() && !t2.hasAttributes();
    }
    copy() {
      const t2 = (arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {}).consolidateBlocks ? this.blockList.consolidate().toArray() : this.blockList.toArray();
      return new this.constructor(t2);
    }
    copyUsingObjectsFromDocument(t2) {
      const e2 = new Yt(t2.getObjects());
      return this.copyUsingObjectMap(e2);
    }
    copyUsingObjectMap(t2) {
      const e2 = this.getBlocks().map((e3) => t2.find(e3) || e3.copyUsingObjectMap(t2));
      return new this.constructor(e2);
    }
    copyWithBaseBlockAttributes() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : [];
      const e2 = this.getBlocks().map((e3) => {
        const i2 = t2.concat(e3.getAttributes());
        return e3.copyWithAttributes(i2);
      });
      return new this.constructor(e2);
    }
    replaceBlock(t2, e2) {
      const i2 = this.blockList.indexOf(t2);
      return -1 === i2 ? this : new this.constructor(this.blockList.replaceObjectAtIndex(e2, i2));
    }
    insertDocumentAtRange(t2, e2) {
      const { blockList: i2 } = t2;
      e2 = Lt(e2);
      let [n2] = e2;
      const { index: r2, offset: o2 } = this.locationFromPosition(n2);
      let s2 = this;
      const a2 = this.getBlockAtPosition(n2);
      return Dt(e2) && a2.isEmpty() && !a2.hasAttributes() ? s2 = new this.constructor(s2.blockList.removeObjectAtIndex(r2)) : a2.getBlockBreakPosition() === o2 && n2++, s2 = s2.removeTextAtRange(e2), new this.constructor(s2.blockList.insertSplittableListAtPosition(i2, n2));
    }
    mergeDocumentAtRange(t2, e2) {
      let i2, n2;
      e2 = Lt(e2);
      const [r2] = e2, o2 = this.locationFromPosition(r2), s2 = this.getBlockAtIndex(o2.index).getAttributes(), a2 = t2.getBaseBlockAttributes(), l2 = s2.slice(-a2.length);
      if (rt(a2, l2)) {
        const e3 = s2.slice(0, -a2.length);
        i2 = t2.copyWithBaseBlockAttributes(e3);
      } else
        i2 = t2.copy({ consolidateBlocks: true }).copyWithBaseBlockAttributes(s2);
      const c2 = i2.getBlockCount(), u2 = i2.getBlockAtIndex(0);
      if (rt(s2, u2.getAttributes())) {
        const t3 = u2.getTextWithoutBlockBreak();
        if (n2 = this.insertTextAtRange(t3, e2), c2 > 1) {
          i2 = new this.constructor(i2.getBlocks().slice(1));
          const e3 = r2 + t3.getLength();
          n2 = n2.insertDocumentAtRange(i2, e3);
        }
      } else
        n2 = this.insertDocumentAtRange(i2, e2);
      return n2;
    }
    insertTextAtRange(t2, e2) {
      e2 = Lt(e2);
      const [i2] = e2, { index: n2, offset: r2 } = this.locationFromPosition(i2), o2 = this.removeTextAtRange(e2);
      return new this.constructor(o2.blockList.editObjectAtIndex(n2, (e3) => e3.copyWithText(e3.text.insertTextAtPosition(t2, r2))));
    }
    removeTextAtRange(t2) {
      let e2;
      t2 = Lt(t2);
      const [i2, n2] = t2;
      if (Dt(t2))
        return this;
      const [r2, o2] = Array.from(this.locationRangeFromRange(t2)), s2 = r2.index, a2 = r2.offset, l2 = this.getBlockAtIndex(s2), c2 = o2.index, u2 = o2.offset, h2 = this.getBlockAtIndex(c2);
      if (n2 - i2 == 1 && l2.getBlockBreakPosition() === a2 && h2.getBlockBreakPosition() !== u2 && "\n" === h2.text.getStringAtPosition(u2))
        e2 = this.blockList.editObjectAtIndex(c2, (t3) => t3.copyWithText(t3.text.removeTextAtRange([u2, u2 + 1])));
      else {
        let t3;
        const i3 = l2.text.getTextAtRange([0, a2]), n3 = h2.text.getTextAtRange([u2, h2.getLength()]), r3 = i3.appendText(n3);
        t3 = s2 !== c2 && 0 === a2 && l2.getAttributeLevel() >= h2.getAttributeLevel() ? h2.copyWithText(r3) : l2.copyWithText(r3);
        const o3 = c2 + 1 - s2;
        e2 = this.blockList.splice(s2, o3, t3);
      }
      return new this.constructor(e2);
    }
    moveTextFromRangeToPosition(t2, e2) {
      let i2;
      t2 = Lt(t2);
      const [n2, r2] = t2;
      if (n2 <= e2 && e2 <= r2)
        return this;
      let o2 = this.getDocumentAtRange(t2), s2 = this.removeTextAtRange(t2);
      const a2 = n2 < e2;
      a2 && (e2 -= o2.getLength());
      const [l2, ...c2] = o2.getBlocks();
      return 0 === c2.length ? (i2 = l2.getTextWithoutBlockBreak(), a2 && (e2 += 1)) : i2 = l2.text, s2 = s2.insertTextAtRange(i2, e2), 0 === c2.length ? s2 : (o2 = new this.constructor(c2), e2 += i2.getLength(), s2.insertDocumentAtRange(o2, e2));
    }
    addAttributeAtRange(t2, e2, i2) {
      let { blockList: n2 } = this;
      return this.eachBlockAtRange(i2, (i3, r2, o2) => n2 = n2.editObjectAtIndex(o2, function() {
        return gt(t2) ? i3.addAttribute(t2, e2) : r2[0] === r2[1] ? i3 : i3.copyWithText(i3.text.addAttributeAtRange(t2, e2, r2));
      })), new this.constructor(n2);
    }
    addAttribute(t2, e2) {
      let { blockList: i2 } = this;
      return this.eachBlock((n2, r2) => i2 = i2.editObjectAtIndex(r2, () => n2.addAttribute(t2, e2))), new this.constructor(i2);
    }
    removeAttributeAtRange(t2, e2) {
      let { blockList: i2 } = this;
      return this.eachBlockAtRange(e2, function(e3, n2, r2) {
        gt(t2) ? i2 = i2.editObjectAtIndex(r2, () => e3.removeAttribute(t2)) : n2[0] !== n2[1] && (i2 = i2.editObjectAtIndex(r2, () => e3.copyWithText(e3.text.removeAttributeAtRange(t2, n2))));
      }), new this.constructor(i2);
    }
    updateAttributesForAttachment(t2, e2) {
      const i2 = this.getRangeOfAttachment(e2), [n2] = Array.from(i2), { index: r2 } = this.locationFromPosition(n2), o2 = this.getTextAtIndex(r2);
      return new this.constructor(this.blockList.editObjectAtIndex(r2, (i3) => i3.copyWithText(o2.updateAttributesForAttachment(t2, e2))));
    }
    removeAttributeForAttachment(t2, e2) {
      const i2 = this.getRangeOfAttachment(e2);
      return this.removeAttributeAtRange(t2, i2);
    }
    setHTMLAttributeAtPosition(t2, e2, i2) {
      const n2 = this.getBlockAtPosition(t2), r2 = n2.addHTMLAttribute(e2, i2);
      return this.replaceBlock(n2, r2);
    }
    insertBlockBreakAtRange(t2) {
      let e2;
      t2 = Lt(t2);
      const [i2] = t2, { offset: n2 } = this.locationFromPosition(i2), r2 = this.removeTextAtRange(t2);
      return 0 === n2 && (e2 = [new Oe()]), new this.constructor(r2.blockList.insertSplittableListAtPosition(new Be(e2), i2));
    }
    applyBlockAttributeAtRange(t2, e2, i2) {
      const n2 = this.expandRangeToLineBreaksAndSplitBlocks(i2);
      let r2 = n2.document;
      i2 = n2.range;
      const o2 = gt(t2);
      if (o2.listAttribute) {
        r2 = r2.removeLastListAttributeAtRange(i2, { exceptAttributeName: t2 });
        const e3 = r2.convertLineBreaksToBlockBreaksInRange(i2);
        r2 = e3.document, i2 = e3.range;
      } else
        r2 = o2.exclusive ? r2.removeBlockAttributesAtRange(i2) : o2.terminal ? r2.removeLastTerminalAttributeAtRange(i2) : r2.consolidateBlocksAtRange(i2);
      return r2.addAttributeAtRange(t2, e2, i2);
    }
    removeLastListAttributeAtRange(t2) {
      let e2 = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {}, { blockList: i2 } = this;
      return this.eachBlockAtRange(t2, function(t3, n2, r2) {
        const o2 = t3.getLastAttribute();
        o2 && gt(o2).listAttribute && o2 !== e2.exceptAttributeName && (i2 = i2.editObjectAtIndex(r2, () => t3.removeAttribute(o2)));
      }), new this.constructor(i2);
    }
    removeLastTerminalAttributeAtRange(t2) {
      let { blockList: e2 } = this;
      return this.eachBlockAtRange(t2, function(t3, i2, n2) {
        const r2 = t3.getLastAttribute();
        r2 && gt(r2).terminal && (e2 = e2.editObjectAtIndex(n2, () => t3.removeAttribute(r2)));
      }), new this.constructor(e2);
    }
    removeBlockAttributesAtRange(t2) {
      let { blockList: e2 } = this;
      return this.eachBlockAtRange(t2, function(t3, i2, n2) {
        t3.hasAttributes() && (e2 = e2.editObjectAtIndex(n2, () => t3.copyWithoutAttributes()));
      }), new this.constructor(e2);
    }
    expandRangeToLineBreaksAndSplitBlocks(t2) {
      let e2;
      t2 = Lt(t2);
      let [i2, n2] = t2;
      const r2 = this.locationFromPosition(i2), o2 = this.locationFromPosition(n2);
      let s2 = this;
      const a2 = s2.getBlockAtIndex(r2.index);
      if (r2.offset = a2.findLineBreakInDirectionFromPosition("backward", r2.offset), null != r2.offset && (e2 = s2.positionFromLocation(r2), s2 = s2.insertBlockBreakAtRange([e2, e2 + 1]), o2.index += 1, o2.offset -= s2.getBlockAtIndex(r2.index).getLength(), r2.index += 1), r2.offset = 0, 0 === o2.offset && o2.index > r2.index)
        o2.index -= 1, o2.offset = s2.getBlockAtIndex(o2.index).getBlockBreakPosition();
      else {
        const t3 = s2.getBlockAtIndex(o2.index);
        "\n" === t3.text.getStringAtRange([o2.offset - 1, o2.offset]) ? o2.offset -= 1 : o2.offset = t3.findLineBreakInDirectionFromPosition("forward", o2.offset), o2.offset !== t3.getBlockBreakPosition() && (e2 = s2.positionFromLocation(o2), s2 = s2.insertBlockBreakAtRange([e2, e2 + 1]));
      }
      return i2 = s2.positionFromLocation(r2), n2 = s2.positionFromLocation(o2), { document: s2, range: t2 = Lt([i2, n2]) };
    }
    convertLineBreaksToBlockBreaksInRange(t2) {
      t2 = Lt(t2);
      let [e2] = t2;
      const i2 = this.getStringAtRange(t2).slice(0, -1);
      let n2 = this;
      return i2.replace(/.*?\n/g, function(t3) {
        e2 += t3.length, n2 = n2.insertBlockBreakAtRange([e2 - 1, e2]);
      }), { document: n2, range: t2 };
    }
    consolidateBlocksAtRange(t2) {
      t2 = Lt(t2);
      const [e2, i2] = t2, n2 = this.locationFromPosition(e2).index, r2 = this.locationFromPosition(i2).index;
      return new this.constructor(this.blockList.consolidateFromIndexToIndex(n2, r2));
    }
    getDocumentAtRange(t2) {
      t2 = Lt(t2);
      const e2 = this.blockList.getSplittableListInRange(t2).toArray();
      return new this.constructor(e2);
    }
    getStringAtRange(t2) {
      let e2;
      const i2 = t2 = Lt(t2);
      return i2[i2.length - 1] !== this.getLength() && (e2 = -1), this.getDocumentAtRange(t2).toString().slice(0, e2);
    }
    getBlockAtIndex(t2) {
      return this.blockList.getObjectAtIndex(t2);
    }
    getBlockAtPosition(t2) {
      const { index: e2 } = this.locationFromPosition(t2);
      return this.getBlockAtIndex(e2);
    }
    getTextAtIndex(t2) {
      var e2;
      return null === (e2 = this.getBlockAtIndex(t2)) || void 0 === e2 ? void 0 : e2.text;
    }
    getTextAtPosition(t2) {
      const { index: e2 } = this.locationFromPosition(t2);
      return this.getTextAtIndex(e2);
    }
    getPieceAtPosition(t2) {
      const { index: e2, offset: i2 } = this.locationFromPosition(t2);
      return this.getTextAtIndex(e2).getPieceAtPosition(i2);
    }
    getCharacterAtPosition(t2) {
      const { index: e2, offset: i2 } = this.locationFromPosition(t2);
      return this.getTextAtIndex(e2).getStringAtRange([i2, i2 + 1]);
    }
    getLength() {
      return this.blockList.getEndPosition();
    }
    getBlocks() {
      return this.blockList.toArray();
    }
    getBlockCount() {
      return this.blockList.length;
    }
    getEditCount() {
      return this.editCount;
    }
    eachBlock(t2) {
      return this.blockList.eachObject(t2);
    }
    eachBlockAtRange(t2, e2) {
      let i2, n2;
      t2 = Lt(t2);
      const [r2, o2] = t2, s2 = this.locationFromPosition(r2), a2 = this.locationFromPosition(o2);
      if (s2.index === a2.index)
        return i2 = this.getBlockAtIndex(s2.index), n2 = [s2.offset, a2.offset], e2(i2, n2, s2.index);
      for (let t3 = s2.index; t3 <= a2.index; t3++)
        if (i2 = this.getBlockAtIndex(t3), i2) {
          switch (t3) {
            case s2.index:
              n2 = [s2.offset, i2.text.getLength()];
              break;
            case a2.index:
              n2 = [0, a2.offset];
              break;
            default:
              n2 = [0, i2.text.getLength()];
          }
          e2(i2, n2, t3);
        }
    }
    getCommonAttributesAtRange(t2) {
      t2 = Lt(t2);
      const [e2] = t2;
      if (Dt(t2))
        return this.getCommonAttributesAtPosition(e2);
      {
        const e3 = [], i2 = [];
        return this.eachBlockAtRange(t2, function(t3, n2) {
          if (n2[0] !== n2[1])
            return e3.push(t3.text.getCommonAttributesAtRange(n2)), i2.push(Ke(t3));
        }), zt.fromCommonAttributesOfObjects(e3).merge(zt.fromCommonAttributesOfObjects(i2)).toObject();
      }
    }
    getCommonAttributesAtPosition(t2) {
      let e2, i2;
      const { index: n2, offset: r2 } = this.locationFromPosition(t2), o2 = this.getBlockAtIndex(n2);
      if (!o2)
        return {};
      const s2 = Ke(o2), a2 = o2.text.getAttributesAtPosition(r2), l2 = o2.text.getAttributesAtPosition(r2 - 1), c2 = Object.keys(W).filter((t3) => W[t3].inheritable);
      for (e2 in l2)
        i2 = l2[e2], (i2 === a2[e2] || c2.includes(e2)) && (s2[e2] = i2);
      return s2;
    }
    getRangeOfCommonAttributeAtPosition(t2, e2) {
      const { index: i2, offset: n2 } = this.locationFromPosition(e2), r2 = this.getTextAtIndex(i2), [o2, s2] = Array.from(r2.getExpandedRangeForAttributeAtOffset(t2, n2)), a2 = this.positionFromLocation({ index: i2, offset: o2 }), l2 = this.positionFromLocation({ index: i2, offset: s2 });
      return Lt([a2, l2]);
    }
    getBaseBlockAttributes() {
      let t2 = this.getBlockAtIndex(0).getAttributes();
      for (let e2 = 1; e2 < this.getBlockCount(); e2++) {
        const i2 = this.getBlockAtIndex(e2).getAttributes(), n2 = Math.min(t2.length, i2.length);
        t2 = (() => {
          const e3 = [];
          for (let r2 = 0; r2 < n2 && i2[r2] === t2[r2]; r2++)
            e3.push(i2[r2]);
          return e3;
        })();
      }
      return t2;
    }
    getAttachmentById(t2) {
      for (const e2 of this.getAttachments())
        if (e2.id === t2)
          return e2;
    }
    getAttachmentPieces() {
      let t2 = [];
      return this.blockList.eachObject((e2) => {
        let { text: i2 } = e2;
        return t2 = t2.concat(i2.getAttachmentPieces());
      }), t2;
    }
    getAttachments() {
      return this.getAttachmentPieces().map((t2) => t2.attachment);
    }
    getRangeOfAttachment(t2) {
      let e2 = 0;
      const i2 = this.blockList.toArray();
      for (let n2 = 0; n2 < i2.length; n2++) {
        const { text: r2 } = i2[n2], o2 = r2.getRangeOfAttachment(t2);
        if (o2)
          return Lt([e2 + o2[0], e2 + o2[1]]);
        e2 += r2.getLength();
      }
    }
    getLocationRangeOfAttachment(t2) {
      const e2 = this.getRangeOfAttachment(t2);
      return this.locationRangeFromRange(e2);
    }
    getAttachmentPieceForAttachment(t2) {
      for (const e2 of this.getAttachmentPieces())
        if (e2.attachment === t2)
          return e2;
    }
    findRangesForBlockAttribute(t2) {
      let e2 = 0;
      const i2 = [];
      return this.getBlocks().forEach((n2) => {
        const r2 = n2.getLength();
        n2.hasAttribute(t2) && i2.push([e2, e2 + r2]), e2 += r2;
      }), i2;
    }
    findRangesForTextAttribute(t2) {
      let { withValue: e2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {}, i2 = 0, n2 = [];
      const r2 = [];
      return this.getPieces().forEach((o2) => {
        const s2 = o2.getLength();
        (function(i3) {
          return e2 ? i3.getAttribute(t2) === e2 : i3.hasAttribute(t2);
        })(o2) && (n2[1] === i2 ? n2[1] = i2 + s2 : r2.push(n2 = [i2, i2 + s2])), i2 += s2;
      }), r2;
    }
    locationFromPosition(t2) {
      const e2 = this.blockList.findIndexAndOffsetAtPosition(Math.max(0, t2));
      if (null != e2.index)
        return e2;
      {
        const t3 = this.getBlocks();
        return { index: t3.length - 1, offset: t3[t3.length - 1].getLength() };
      }
    }
    positionFromLocation(t2) {
      return this.blockList.findPositionAtIndexAndOffset(t2.index, t2.offset);
    }
    locationRangeFromPosition(t2) {
      return Lt(this.locationFromPosition(t2));
    }
    locationRangeFromRange(t2) {
      if (!(t2 = Lt(t2)))
        return;
      const [e2, i2] = Array.from(t2), n2 = this.locationFromPosition(e2), r2 = this.locationFromPosition(i2);
      return Lt([n2, r2]);
    }
    rangeFromLocationRange(t2) {
      let e2;
      t2 = Lt(t2);
      const i2 = this.positionFromLocation(t2[0]);
      return Dt(t2) || (e2 = this.positionFromLocation(t2[1])), Lt([i2, e2]);
    }
    isEqualTo(t2) {
      return this.blockList.isEqualTo(null == t2 ? void 0 : t2.blockList);
    }
    getTexts() {
      return this.getBlocks().map((t2) => t2.text);
    }
    getPieces() {
      const t2 = [];
      return Array.from(this.getTexts()).forEach((e2) => {
        t2.push(...Array.from(e2.getPieces() || []));
      }), t2;
    }
    getObjects() {
      return this.getBlocks().concat(this.getTexts()).concat(this.getPieces());
    }
    toSerializableDocument() {
      const t2 = [];
      return this.blockList.eachObject((e2) => t2.push(e2.copyWithText(e2.text.toSerializableText()))), new this.constructor(t2);
    }
    toString() {
      return this.blockList.toString();
    }
    toJSON() {
      return this.blockList.toJSON();
    }
    toConsole() {
      return JSON.stringify(this.blockList.toArray().map((t2) => JSON.parse(t2.text.toConsole())));
    }
  };
  var Ke = function(t2) {
    const e2 = {}, i2 = t2.getLastAttribute();
    return i2 && (e2[i2] = true), e2;
  };
  var Ge = function(t2) {
    let e2 = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
    return { string: t2 = Wt(t2), attributes: e2, type: "string" };
  };
  var $e = (t2, e2) => {
    try {
      return JSON.parse(t2.getAttribute("data-trix-".concat(e2)));
    } catch (t3) {
      return {};
    }
  };
  var Xe = class extends H {
    static parse(t2, e2) {
      const i2 = new this(t2, e2);
      return i2.parse(), i2;
    }
    constructor(t2) {
      let { referenceElement: e2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
      super(...arguments), this.html = t2, this.referenceElement = e2, this.blocks = [], this.blockElements = [], this.processedElements = [];
    }
    getDocument() {
      return Je.fromJSON(this.blocks);
    }
    parse() {
      try {
        this.createHiddenContainer(), se.setHTML(this.containerElement, this.html);
        const t2 = R(this.containerElement, { usingFilter: ti });
        for (; t2.nextNode(); )
          this.processNode(t2.currentNode);
        return this.translateBlockElementMarginsToNewlines();
      } finally {
        this.removeHiddenContainer();
      }
    }
    createHiddenContainer() {
      return this.referenceElement ? (this.containerElement = this.referenceElement.cloneNode(false), this.containerElement.removeAttribute("id"), this.containerElement.setAttribute("data-trix-internal", ""), this.containerElement.style.display = "none", this.referenceElement.parentNode.insertBefore(this.containerElement, this.referenceElement.nextSibling)) : (this.containerElement = S({ tagName: "div", style: { display: "none" } }), document.body.appendChild(this.containerElement));
    }
    removeHiddenContainer() {
      return k(this.containerElement);
    }
    processNode(t2) {
      switch (t2.nodeType) {
        case Node.TEXT_NODE:
          if (!this.isInsignificantTextNode(t2))
            return this.appendBlockForTextNode(t2), this.processTextNode(t2);
          break;
        case Node.ELEMENT_NODE:
          return this.appendBlockForElement(t2), this.processElement(t2);
      }
    }
    appendBlockForTextNode(t2) {
      const e2 = t2.parentNode;
      if (e2 === this.currentBlockElement && this.isBlockElement(t2.previousSibling))
        return this.appendStringWithAttributes("\n");
      if (e2 === this.containerElement || this.isBlockElement(e2)) {
        var i2;
        const t3 = this.getBlockAttributes(e2), n2 = this.getBlockHTMLAttributes(e2);
        rt(t3, null === (i2 = this.currentBlock) || void 0 === i2 ? void 0 : i2.attributes) || (this.currentBlock = this.appendBlockForAttributesWithElement(t3, e2, n2), this.currentBlockElement = e2);
      }
    }
    appendBlockForElement(t2) {
      const e2 = this.isBlockElement(t2), i2 = y(this.currentBlockElement, t2);
      if (e2 && !this.isBlockElement(t2.firstChild)) {
        if (!this.isInsignificantTextNode(t2.firstChild) || !this.isBlockElement(t2.firstElementChild)) {
          const e3 = this.getBlockAttributes(t2), n2 = this.getBlockHTMLAttributes(t2);
          if (t2.firstChild) {
            if (i2 && rt(e3, this.currentBlock.attributes))
              return this.appendStringWithAttributes("\n");
            this.currentBlock = this.appendBlockForAttributesWithElement(e3, t2, n2), this.currentBlockElement = t2;
          }
        }
      } else if (this.currentBlockElement && !i2 && !e2) {
        const e3 = this.findParentBlockElement(t2);
        if (e3)
          return this.appendBlockForElement(e3);
        this.currentBlock = this.appendEmptyBlock(), this.currentBlockElement = null;
      }
    }
    findParentBlockElement(t2) {
      let { parentElement: e2 } = t2;
      for (; e2 && e2 !== this.containerElement; ) {
        if (this.isBlockElement(e2) && this.blockElements.includes(e2))
          return e2;
        e2 = e2.parentElement;
      }
      return null;
    }
    processTextNode(t2) {
      let e2 = t2.data;
      var i2;
      Ye(t2.parentNode) || (e2 = qt(e2), ni(null === (i2 = t2.previousSibling) || void 0 === i2 ? void 0 : i2.textContent) && (e2 = ei(e2)));
      return this.appendStringWithAttributes(e2, this.getTextAttributes(t2.parentNode));
    }
    processElement(t2) {
      let e2;
      if (I(t2)) {
        if (e2 = $e(t2, "attachment"), Object.keys(e2).length) {
          const i2 = this.getTextAttributes(t2);
          this.appendAttachmentWithAttributes(e2, i2), t2.innerHTML = "";
        }
        return this.processedElements.push(t2);
      }
      switch (E(t2)) {
        case "br":
          return this.isExtraBR(t2) || this.isBlockElement(t2.nextSibling) || this.appendStringWithAttributes("\n", this.getTextAttributes(t2)), this.processedElements.push(t2);
        case "img":
          e2 = { url: t2.getAttribute("src"), contentType: "image" };
          const i2 = ((t3) => {
            const e3 = t3.getAttribute("width"), i3 = t3.getAttribute("height"), n2 = {};
            return e3 && (n2.width = parseInt(e3, 10)), i3 && (n2.height = parseInt(i3, 10)), n2;
          })(t2);
          for (const t3 in i2) {
            const n2 = i2[t3];
            e2[t3] = n2;
          }
          return this.appendAttachmentWithAttributes(e2, this.getTextAttributes(t2)), this.processedElements.push(t2);
        case "tr":
          if (this.needsTableSeparator(t2))
            return this.appendStringWithAttributes(j.tableRowSeparator);
          break;
        case "td":
          if (this.needsTableSeparator(t2))
            return this.appendStringWithAttributes(j.tableCellSeparator);
      }
    }
    appendBlockForAttributesWithElement(t2, e2) {
      let i2 = arguments.length > 2 && void 0 !== arguments[2] ? arguments[2] : {};
      this.blockElements.push(e2);
      const n2 = function() {
        return { text: [], attributes: arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {}, htmlAttributes: arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {} };
      }(t2, i2);
      return this.blocks.push(n2), n2;
    }
    appendEmptyBlock() {
      return this.appendBlockForAttributesWithElement([], null);
    }
    appendStringWithAttributes(t2, e2) {
      return this.appendPiece(Ge(t2, e2));
    }
    appendAttachmentWithAttributes(t2, e2) {
      return this.appendPiece(function(t3) {
        return { attachment: t3, attributes: arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {}, type: "attachment" };
      }(t2, e2));
    }
    appendPiece(t2) {
      return 0 === this.blocks.length && this.appendEmptyBlock(), this.blocks[this.blocks.length - 1].text.push(t2);
    }
    appendStringToTextAtIndex(t2, e2) {
      const { text: i2 } = this.blocks[e2], n2 = i2[i2.length - 1];
      if ("string" !== (null == n2 ? void 0 : n2.type))
        return i2.push(Ge(t2));
      n2.string += t2;
    }
    prependStringToTextAtIndex(t2, e2) {
      const { text: i2 } = this.blocks[e2], n2 = i2[0];
      if ("string" !== (null == n2 ? void 0 : n2.type))
        return i2.unshift(Ge(t2));
      n2.string = t2 + n2.string;
    }
    getTextAttributes(t2) {
      let e2;
      const i2 = {};
      for (const n2 in W) {
        const r2 = W[n2];
        if (r2.tagName && A(t2, { matchingSelector: r2.tagName, untilNode: this.containerElement }))
          i2[n2] = true;
        else if (r2.parser) {
          if (e2 = r2.parser(t2), e2) {
            let o2 = false;
            for (const i3 of this.findBlockElementAncestors(t2))
              if (r2.parser(i3) === e2) {
                o2 = true;
                break;
              }
            o2 || (i2[n2] = e2);
          }
        } else
          r2.styleProperty && (e2 = t2.style[r2.styleProperty], e2 && (i2[n2] = e2));
      }
      if (I(t2)) {
        const n2 = $e(t2, "attributes");
        for (const t3 in n2)
          e2 = n2[t3], i2[t3] = e2;
      }
      return i2;
    }
    getBlockAttributes(t2) {
      const e2 = [];
      for (; t2 && t2 !== this.containerElement; ) {
        for (const r2 in n) {
          const o2 = n[r2];
          var i2;
          if (false !== o2.parse) {
            if (E(t2) === o2.tagName)
              (null !== (i2 = o2.test) && void 0 !== i2 && i2.call(o2, t2) || !o2.test) && (e2.push(r2), o2.listAttribute && e2.push(o2.listAttribute));
          }
        }
        t2 = t2.parentNode;
      }
      return e2.reverse();
    }
    getBlockHTMLAttributes(t2) {
      const e2 = {}, i2 = Object.values(n).find((e3) => e3.tagName === E(t2));
      return ((null == i2 ? void 0 : i2.htmlAttributes) || []).forEach((i3) => {
        t2.hasAttribute(i3) && (e2[i3] = t2.getAttribute(i3));
      }), e2;
    }
    findBlockElementAncestors(t2) {
      const e2 = [];
      for (; t2 && t2 !== this.containerElement; ) {
        const i2 = E(t2);
        D().includes(i2) && e2.push(t2), t2 = t2.parentNode;
      }
      return e2;
    }
    isBlockElement(t2) {
      if ((null == t2 ? void 0 : t2.nodeType) === Node.ELEMENT_NODE && !I(t2) && !A(t2, { matchingSelector: "td", untilNode: this.containerElement }))
        return D().includes(E(t2)) || "block" === window.getComputedStyle(t2).display;
    }
    isInsignificantTextNode(t2) {
      if ((null == t2 ? void 0 : t2.nodeType) !== Node.TEXT_NODE)
        return;
      if (!ii(t2.data))
        return;
      const { parentNode: e2, previousSibling: i2, nextSibling: n2 } = t2;
      return Qe(e2.previousSibling) && !this.isBlockElement(e2.previousSibling) || Ye(e2) ? void 0 : !i2 || this.isBlockElement(i2) || !n2 || this.isBlockElement(n2);
    }
    isExtraBR(t2) {
      return "br" === E(t2) && this.isBlockElement(t2.parentNode) && t2.parentNode.lastChild === t2;
    }
    needsTableSeparator(t2) {
      if (j.removeBlankTableCells) {
        var e2;
        const i2 = null === (e2 = t2.previousSibling) || void 0 === e2 ? void 0 : e2.textContent;
        return i2 && /\S/.test(i2);
      }
      return t2.previousSibling;
    }
    translateBlockElementMarginsToNewlines() {
      const t2 = this.getMarginOfDefaultBlockElement();
      for (let e2 = 0; e2 < this.blocks.length; e2++) {
        const i2 = this.getMarginOfBlockElementAtIndex(e2);
        i2 && (i2.top > 2 * t2.top && this.prependStringToTextAtIndex("\n", e2), i2.bottom > 2 * t2.bottom && this.appendStringToTextAtIndex("\n", e2));
      }
    }
    getMarginOfBlockElementAtIndex(t2) {
      const e2 = this.blockElements[t2];
      if (e2 && e2.textContent && !D().includes(E(e2)) && !this.processedElements.includes(e2))
        return Ze(e2);
    }
    getMarginOfDefaultBlockElement() {
      const t2 = S(n.default.tagName);
      return this.containerElement.appendChild(t2), Ze(t2);
    }
  };
  var Ye = function(t2) {
    const { whiteSpace: e2 } = window.getComputedStyle(t2);
    return ["pre", "pre-wrap", "pre-line"].includes(e2);
  };
  var Qe = (t2) => t2 && !ni(t2.textContent);
  var Ze = function(t2) {
    const e2 = window.getComputedStyle(t2);
    if ("block" === e2.display)
      return { top: parseInt(e2.marginTop), bottom: parseInt(e2.marginBottom) };
  };
  var ti = function(t2) {
    return "style" === E(t2) ? NodeFilter.FILTER_REJECT : NodeFilter.FILTER_ACCEPT;
  };
  var ei = (t2) => t2.replace(new RegExp("^".concat(Ut.source, "+")), "");
  var ii = (t2) => new RegExp("^".concat(Ut.source, "*$")).test(t2);
  var ni = (t2) => /\s$/.test(t2);
  var ri = ["contenteditable", "data-trix-id", "data-trix-store-key", "data-trix-mutable", "data-trix-placeholder", "tabindex"];
  var oi = "data-trix-serialized-attributes";
  var si = "[".concat(oi, "]");
  var ai = new RegExp("<!--block-->", "g");
  var li = { "application/json": function(t2) {
    let e2;
    if (t2 instanceof Je)
      e2 = t2;
    else {
      if (!(t2 instanceof HTMLElement))
        throw new Error("unserializable object");
      e2 = Xe.parse(t2.innerHTML).getDocument();
    }
    return e2.toSerializableDocument().toJSONString();
  }, "text/html": function(t2) {
    let e2;
    if (t2 instanceof Je)
      e2 = ve.render(t2);
    else {
      if (!(t2 instanceof HTMLElement))
        throw new Error("unserializable object");
      e2 = t2.cloneNode(true);
    }
    return Array.from(e2.querySelectorAll("[data-trix-serialize=false]")).forEach((t3) => {
      k(t3);
    }), ri.forEach((t3) => {
      Array.from(e2.querySelectorAll("[".concat(t3, "]"))).forEach((e3) => {
        e3.removeAttribute(t3);
      });
    }), Array.from(e2.querySelectorAll(si)).forEach((t3) => {
      try {
        const e3 = JSON.parse(t3.getAttribute(oi));
        t3.removeAttribute(oi);
        for (const i2 in e3) {
          const n2 = e3[i2];
          t3.setAttribute(i2, n2);
        }
      } catch (t4) {
      }
    }), e2.innerHTML.replace(ai, "");
  } };
  var ci = Object.freeze({ __proto__: null });
  var ui = class extends H {
    constructor(t2, e2) {
      super(...arguments), this.attachmentManager = t2, this.attachment = e2, this.id = this.attachment.id, this.file = this.attachment.file;
    }
    remove() {
      return this.attachmentManager.requestRemovalOfAttachment(this.attachment);
    }
  };
  ui.proxyMethod("attachment.getAttribute"), ui.proxyMethod("attachment.hasAttribute"), ui.proxyMethod("attachment.setAttribute"), ui.proxyMethod("attachment.getAttributes"), ui.proxyMethod("attachment.setAttributes"), ui.proxyMethod("attachment.isPending"), ui.proxyMethod("attachment.isPreviewable"), ui.proxyMethod("attachment.getURL"), ui.proxyMethod("attachment.getHref"), ui.proxyMethod("attachment.getFilename"), ui.proxyMethod("attachment.getFilesize"), ui.proxyMethod("attachment.getFormattedFilesize"), ui.proxyMethod("attachment.getExtension"), ui.proxyMethod("attachment.getContentType"), ui.proxyMethod("attachment.getFile"), ui.proxyMethod("attachment.setFile"), ui.proxyMethod("attachment.releaseFile"), ui.proxyMethod("attachment.getUploadProgress"), ui.proxyMethod("attachment.setUploadProgress");
  var hi = class extends H {
    constructor() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : [];
      super(...arguments), this.managedAttachments = {}, Array.from(t2).forEach((t3) => {
        this.manageAttachment(t3);
      });
    }
    getAttachments() {
      const t2 = [];
      for (const e2 in this.managedAttachments) {
        const i2 = this.managedAttachments[e2];
        t2.push(i2);
      }
      return t2;
    }
    manageAttachment(t2) {
      return this.managedAttachments[t2.id] || (this.managedAttachments[t2.id] = new ui(this, t2)), this.managedAttachments[t2.id];
    }
    attachmentIsManaged(t2) {
      return t2.id in this.managedAttachments;
    }
    requestRemovalOfAttachment(t2) {
      var e2, i2;
      if (this.attachmentIsManaged(t2))
        return null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.attachmentManagerDidRequestRemovalOfAttachment) || void 0 === i2 ? void 0 : i2.call(e2, t2);
    }
    unmanageAttachment(t2) {
      const e2 = this.managedAttachments[t2.id];
      return delete this.managedAttachments[t2.id], e2;
    }
  };
  var di = class {
    constructor(t2) {
      this.composition = t2, this.document = this.composition.document;
      const e2 = this.composition.getSelectedRange();
      this.startPosition = e2[0], this.endPosition = e2[1], this.startLocation = this.document.locationFromPosition(this.startPosition), this.endLocation = this.document.locationFromPosition(this.endPosition), this.block = this.document.getBlockAtIndex(this.endLocation.index), this.breaksOnReturn = this.block.breaksOnReturn(), this.previousCharacter = this.block.text.getStringAtPosition(this.endLocation.offset - 1), this.nextCharacter = this.block.text.getStringAtPosition(this.endLocation.offset);
    }
    shouldInsertBlockBreak() {
      return this.block.hasAttributes() && this.block.isListItem() && !this.block.isEmpty() ? 0 !== this.startLocation.offset : this.breaksOnReturn && "\n" !== this.nextCharacter;
    }
    shouldBreakFormattedBlock() {
      return this.block.hasAttributes() && !this.block.isListItem() && (this.breaksOnReturn && "\n" === this.nextCharacter || "\n" === this.previousCharacter);
    }
    shouldDecreaseListLevel() {
      return this.block.hasAttributes() && this.block.isListItem() && this.block.isEmpty();
    }
    shouldPrependListItem() {
      return this.block.isListItem() && 0 === this.startLocation.offset && !this.block.isEmpty();
    }
    shouldRemoveLastBlockAttribute() {
      return this.block.hasAttributes() && !this.block.isListItem() && this.block.isEmpty();
    }
  };
  var gi = class extends H {
    constructor() {
      super(...arguments), this.document = new Je(), this.attachments = [], this.currentAttributes = {}, this.revision = 0;
    }
    setDocument(t2) {
      var e2, i2;
      if (!t2.isEqualTo(this.document))
        return this.document = t2, this.refreshAttachments(), this.revision++, null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.compositionDidChangeDocument) || void 0 === i2 ? void 0 : i2.call(e2, t2);
    }
    getSnapshot() {
      return { document: this.document, selectedRange: this.getSelectedRange() };
    }
    loadSnapshot(t2) {
      var e2, i2, n2, r2;
      let { document: o2, selectedRange: s2 } = t2;
      return null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.compositionWillLoadSnapshot) || void 0 === i2 || i2.call(e2), this.setDocument(null != o2 ? o2 : new Je()), this.setSelection(null != s2 ? s2 : [0, 0]), null === (n2 = this.delegate) || void 0 === n2 || null === (r2 = n2.compositionDidLoadSnapshot) || void 0 === r2 ? void 0 : r2.call(n2);
    }
    insertText(t2) {
      let { updatePosition: e2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : { updatePosition: true };
      const i2 = this.getSelectedRange();
      this.setDocument(this.document.insertTextAtRange(t2, i2));
      const n2 = i2[0], r2 = n2 + t2.getLength();
      return e2 && this.setSelection(r2), this.notifyDelegateOfInsertionAtRange([n2, r2]);
    }
    insertBlock() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : new Oe();
      const e2 = new Je([t2]);
      return this.insertDocument(e2);
    }
    insertDocument() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : new Je();
      const e2 = this.getSelectedRange();
      this.setDocument(this.document.insertDocumentAtRange(t2, e2));
      const i2 = e2[0], n2 = i2 + t2.getLength();
      return this.setSelection(n2), this.notifyDelegateOfInsertionAtRange([i2, n2]);
    }
    insertString(t2, e2) {
      const i2 = this.getCurrentTextAttributes(), n2 = Ne.textForStringWithAttributes(t2, i2);
      return this.insertText(n2, e2);
    }
    insertBlockBreak() {
      const t2 = this.getSelectedRange();
      this.setDocument(this.document.insertBlockBreakAtRange(t2));
      const e2 = t2[0], i2 = e2 + 1;
      return this.setSelection(i2), this.notifyDelegateOfInsertionAtRange([e2, i2]);
    }
    insertLineBreak() {
      const t2 = new di(this);
      if (t2.shouldDecreaseListLevel())
        return this.decreaseListLevel(), this.setSelection(t2.startPosition);
      if (t2.shouldPrependListItem()) {
        const e2 = new Je([t2.block.copyWithoutText()]);
        return this.insertDocument(e2);
      }
      return t2.shouldInsertBlockBreak() ? this.insertBlockBreak() : t2.shouldRemoveLastBlockAttribute() ? this.removeLastBlockAttribute() : t2.shouldBreakFormattedBlock() ? this.breakFormattedBlock(t2) : this.insertString("\n");
    }
    insertHTML(t2) {
      const e2 = Xe.parse(t2).getDocument(), i2 = this.getSelectedRange();
      this.setDocument(this.document.mergeDocumentAtRange(e2, i2));
      const n2 = i2[0], r2 = n2 + e2.getLength() - 1;
      return this.setSelection(r2), this.notifyDelegateOfInsertionAtRange([n2, r2]);
    }
    replaceHTML(t2) {
      const e2 = Xe.parse(t2).getDocument().copyUsingObjectsFromDocument(this.document), i2 = this.getLocationRange({ strict: false }), n2 = this.document.rangeFromLocationRange(i2);
      return this.setDocument(e2), this.setSelection(n2);
    }
    insertFile(t2) {
      return this.insertFiles([t2]);
    }
    insertFiles(t2) {
      const e2 = [];
      return Array.from(t2).forEach((t3) => {
        var i2;
        if (null !== (i2 = this.delegate) && void 0 !== i2 && i2.compositionShouldAcceptFile(t3)) {
          const i3 = De.attachmentForFile(t3);
          e2.push(i3);
        }
      }), this.insertAttachments(e2);
    }
    insertAttachment(t2) {
      return this.insertAttachments([t2]);
    }
    insertAttachments(t2) {
      let e2 = new Ne();
      return Array.from(t2).forEach((t3) => {
        var n2;
        const r2 = t3.getType(), o2 = null === (n2 = i[r2]) || void 0 === n2 ? void 0 : n2.presentation, s2 = this.getCurrentTextAttributes();
        o2 && (s2.presentation = o2);
        const a2 = Ne.textForAttachmentWithAttributes(t3, s2);
        e2 = e2.appendText(a2);
      }), this.insertText(e2);
    }
    shouldManageDeletingInDirection(t2) {
      const e2 = this.getLocationRange();
      if (Dt(e2)) {
        if ("backward" === t2 && 0 === e2[0].offset)
          return true;
        if (this.shouldManageMovingCursorInDirection(t2))
          return true;
      } else if (e2[0].index !== e2[1].index)
        return true;
      return false;
    }
    deleteInDirection(t2) {
      let e2, i2, n2, { length: r2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
      const o2 = this.getLocationRange();
      let s2 = this.getSelectedRange();
      const a2 = Dt(s2);
      if (a2 ? i2 = "backward" === t2 && 0 === o2[0].offset : n2 = o2[0].index !== o2[1].index, i2 && this.canDecreaseBlockAttributeLevel()) {
        const t3 = this.getBlock();
        if (t3.isListItem() ? this.decreaseListLevel() : this.decreaseBlockAttributeLevel(), this.setSelection(s2[0]), t3.isEmpty())
          return false;
      }
      return a2 && (s2 = this.getExpandedRangeInDirection(t2, { length: r2 }), "backward" === t2 && (e2 = this.getAttachmentAtRange(s2))), e2 ? (this.editAttachment(e2), false) : (this.setDocument(this.document.removeTextAtRange(s2)), this.setSelection(s2[0]), !i2 && !n2 && void 0);
    }
    moveTextFromRange(t2) {
      const [e2] = Array.from(this.getSelectedRange());
      return this.setDocument(this.document.moveTextFromRangeToPosition(t2, e2)), this.setSelection(e2);
    }
    removeAttachment(t2) {
      const e2 = this.document.getRangeOfAttachment(t2);
      if (e2)
        return this.stopEditingAttachment(), this.setDocument(this.document.removeTextAtRange(e2)), this.setSelection(e2[0]);
    }
    removeLastBlockAttribute() {
      const [t2, e2] = Array.from(this.getSelectedRange()), i2 = this.document.getBlockAtPosition(e2);
      return this.removeCurrentAttribute(i2.getLastAttribute()), this.setSelection(t2);
    }
    insertPlaceholder() {
      return this.placeholderPosition = this.getPosition(), this.insertString(" ");
    }
    selectPlaceholder() {
      if (null != this.placeholderPosition)
        return this.setSelectedRange([this.placeholderPosition, this.placeholderPosition + 1]), this.getSelectedRange();
    }
    forgetPlaceholder() {
      this.placeholderPosition = null;
    }
    hasCurrentAttribute(t2) {
      const e2 = this.currentAttributes[t2];
      return null != e2 && false !== e2;
    }
    toggleCurrentAttribute(t2) {
      const e2 = !this.currentAttributes[t2];
      return e2 ? this.setCurrentAttribute(t2, e2) : this.removeCurrentAttribute(t2);
    }
    canSetCurrentAttribute(t2) {
      return gt(t2) ? this.canSetCurrentBlockAttribute(t2) : this.canSetCurrentTextAttribute(t2);
    }
    canSetCurrentTextAttribute(t2) {
      const e2 = this.getSelectedDocument();
      if (e2) {
        for (const t3 of Array.from(e2.getAttachments()))
          if (!t3.hasContent())
            return false;
        return true;
      }
    }
    canSetCurrentBlockAttribute(t2) {
      const e2 = this.getBlock();
      if (e2)
        return !e2.isTerminalBlock();
    }
    setCurrentAttribute(t2, e2) {
      return gt(t2) ? this.setBlockAttribute(t2, e2) : (this.setTextAttribute(t2, e2), this.currentAttributes[t2] = e2, this.notifyDelegateOfCurrentAttributesChange());
    }
    setHTMLAtributeAtPosition(t2, e2, i2) {
      var n2;
      const r2 = this.document.getBlockAtPosition(t2), o2 = null === (n2 = gt(r2.getLastAttribute())) || void 0 === n2 ? void 0 : n2.htmlAttributes;
      if (r2 && null != o2 && o2.includes(e2)) {
        const n3 = this.document.setHTMLAttributeAtPosition(t2, e2, i2);
        this.setDocument(n3);
      }
    }
    setTextAttribute(t2, e2) {
      const i2 = this.getSelectedRange();
      if (!i2)
        return;
      const [n2, r2] = Array.from(i2);
      if (n2 !== r2)
        return this.setDocument(this.document.addAttributeAtRange(t2, e2, i2));
      if ("href" === t2) {
        const t3 = Ne.textForStringWithAttributes(e2, { href: e2 });
        return this.insertText(t3);
      }
    }
    setBlockAttribute(t2, e2) {
      const i2 = this.getSelectedRange();
      if (this.canSetCurrentAttribute(t2))
        return this.setDocument(this.document.applyBlockAttributeAtRange(t2, e2, i2)), this.setSelection(i2);
    }
    removeCurrentAttribute(t2) {
      return gt(t2) ? (this.removeBlockAttribute(t2), this.updateCurrentAttributes()) : (this.removeTextAttribute(t2), delete this.currentAttributes[t2], this.notifyDelegateOfCurrentAttributesChange());
    }
    removeTextAttribute(t2) {
      const e2 = this.getSelectedRange();
      if (e2)
        return this.setDocument(this.document.removeAttributeAtRange(t2, e2));
    }
    removeBlockAttribute(t2) {
      const e2 = this.getSelectedRange();
      if (e2)
        return this.setDocument(this.document.removeAttributeAtRange(t2, e2));
    }
    canDecreaseNestingLevel() {
      var t2;
      return (null === (t2 = this.getBlock()) || void 0 === t2 ? void 0 : t2.getNestingLevel()) > 0;
    }
    canIncreaseNestingLevel() {
      var t2;
      const e2 = this.getBlock();
      if (e2) {
        if (null === (t2 = gt(e2.getLastNestableAttribute())) || void 0 === t2 || !t2.listAttribute)
          return e2.getNestingLevel() > 0;
        {
          const t3 = this.getPreviousBlock();
          if (t3)
            return function() {
              let t4 = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : [];
              return rt((arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : []).slice(0, t4.length), t4);
            }(t3.getListItemAttributes(), e2.getListItemAttributes());
        }
      }
    }
    decreaseNestingLevel() {
      const t2 = this.getBlock();
      if (t2)
        return this.setDocument(this.document.replaceBlock(t2, t2.decreaseNestingLevel()));
    }
    increaseNestingLevel() {
      const t2 = this.getBlock();
      if (t2)
        return this.setDocument(this.document.replaceBlock(t2, t2.increaseNestingLevel()));
    }
    canDecreaseBlockAttributeLevel() {
      var t2;
      return (null === (t2 = this.getBlock()) || void 0 === t2 ? void 0 : t2.getAttributeLevel()) > 0;
    }
    decreaseBlockAttributeLevel() {
      var t2;
      const e2 = null === (t2 = this.getBlock()) || void 0 === t2 ? void 0 : t2.getLastAttribute();
      if (e2)
        return this.removeCurrentAttribute(e2);
    }
    decreaseListLevel() {
      let [t2] = Array.from(this.getSelectedRange());
      const { index: e2 } = this.document.locationFromPosition(t2);
      let i2 = e2;
      const n2 = this.getBlock().getAttributeLevel();
      let r2 = this.document.getBlockAtIndex(i2 + 1);
      for (; r2 && r2.isListItem() && !(r2.getAttributeLevel() <= n2); )
        i2++, r2 = this.document.getBlockAtIndex(i2 + 1);
      t2 = this.document.positionFromLocation({ index: e2, offset: 0 });
      const o2 = this.document.positionFromLocation({ index: i2, offset: 0 });
      return this.setDocument(this.document.removeLastListAttributeAtRange([t2, o2]));
    }
    updateCurrentAttributes() {
      const t2 = this.getSelectedRange({ ignoreLock: true });
      if (t2) {
        const e2 = this.document.getCommonAttributesAtRange(t2);
        if (Array.from(dt()).forEach((t3) => {
          e2[t3] || this.canSetCurrentAttribute(t3) || (e2[t3] = false);
        }), !St(e2, this.currentAttributes))
          return this.currentAttributes = e2, this.notifyDelegateOfCurrentAttributesChange();
      }
    }
    getCurrentAttributes() {
      return g.call({}, this.currentAttributes);
    }
    getCurrentTextAttributes() {
      const t2 = {};
      for (const e2 in this.currentAttributes) {
        const i2 = this.currentAttributes[e2];
        false !== i2 && pt(e2) && (t2[e2] = i2);
      }
      return t2;
    }
    freezeSelection() {
      return this.setCurrentAttribute("frozen", true);
    }
    thawSelection() {
      return this.removeCurrentAttribute("frozen");
    }
    hasFrozenSelection() {
      return this.hasCurrentAttribute("frozen");
    }
    setSelection(t2) {
      var e2;
      const i2 = this.document.locationRangeFromRange(t2);
      return null === (e2 = this.delegate) || void 0 === e2 ? void 0 : e2.compositionDidRequestChangingSelectionToLocationRange(i2);
    }
    getSelectedRange() {
      const t2 = this.getLocationRange();
      if (t2)
        return this.document.rangeFromLocationRange(t2);
    }
    setSelectedRange(t2) {
      const e2 = this.document.locationRangeFromRange(t2);
      return this.getSelectionManager().setLocationRange(e2);
    }
    getPosition() {
      const t2 = this.getLocationRange();
      if (t2)
        return this.document.positionFromLocation(t2[0]);
    }
    getLocationRange(t2) {
      return this.targetLocationRange ? this.targetLocationRange : this.getSelectionManager().getLocationRange(t2) || Lt({ index: 0, offset: 0 });
    }
    withTargetLocationRange(t2, e2) {
      let i2;
      this.targetLocationRange = t2;
      try {
        i2 = e2();
      } finally {
        this.targetLocationRange = null;
      }
      return i2;
    }
    withTargetRange(t2, e2) {
      const i2 = this.document.locationRangeFromRange(t2);
      return this.withTargetLocationRange(i2, e2);
    }
    withTargetDOMRange(t2, e2) {
      const i2 = this.createLocationRangeFromDOMRange(t2, { strict: false });
      return this.withTargetLocationRange(i2, e2);
    }
    getExpandedRangeInDirection(t2) {
      let { length: e2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {}, [i2, n2] = Array.from(this.getSelectedRange());
      return "backward" === t2 ? e2 ? i2 -= e2 : i2 = this.translateUTF16PositionFromOffset(i2, -1) : e2 ? n2 += e2 : n2 = this.translateUTF16PositionFromOffset(n2, 1), Lt([i2, n2]);
    }
    shouldManageMovingCursorInDirection(t2) {
      if (this.editingAttachment)
        return true;
      const e2 = this.getExpandedRangeInDirection(t2);
      return null != this.getAttachmentAtRange(e2);
    }
    moveCursorInDirection(t2) {
      let e2, i2;
      if (this.editingAttachment)
        i2 = this.document.getRangeOfAttachment(this.editingAttachment);
      else {
        const n2 = this.getSelectedRange();
        i2 = this.getExpandedRangeInDirection(t2), e2 = !wt(n2, i2);
      }
      if ("backward" === t2 ? this.setSelectedRange(i2[0]) : this.setSelectedRange(i2[1]), e2) {
        const t3 = this.getAttachmentAtRange(i2);
        if (t3)
          return this.editAttachment(t3);
      }
    }
    expandSelectionInDirection(t2) {
      let { length: e2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
      const i2 = this.getExpandedRangeInDirection(t2, { length: e2 });
      return this.setSelectedRange(i2);
    }
    expandSelectionForEditing() {
      if (this.hasCurrentAttribute("href"))
        return this.expandSelectionAroundCommonAttribute("href");
    }
    expandSelectionAroundCommonAttribute(t2) {
      const e2 = this.getPosition(), i2 = this.document.getRangeOfCommonAttributeAtPosition(t2, e2);
      return this.setSelectedRange(i2);
    }
    selectionContainsAttachments() {
      var t2;
      return (null === (t2 = this.getSelectedAttachments()) || void 0 === t2 ? void 0 : t2.length) > 0;
    }
    selectionIsInCursorTarget() {
      return this.editingAttachment || this.positionIsCursorTarget(this.getPosition());
    }
    positionIsCursorTarget(t2) {
      const e2 = this.document.locationFromPosition(t2);
      if (e2)
        return this.locationIsCursorTarget(e2);
    }
    positionIsBlockBreak(t2) {
      var e2;
      return null === (e2 = this.document.getPieceAtPosition(t2)) || void 0 === e2 ? void 0 : e2.isBlockBreak();
    }
    getSelectedDocument() {
      const t2 = this.getSelectedRange();
      if (t2)
        return this.document.getDocumentAtRange(t2);
    }
    getSelectedAttachments() {
      var t2;
      return null === (t2 = this.getSelectedDocument()) || void 0 === t2 ? void 0 : t2.getAttachments();
    }
    getAttachments() {
      return this.attachments.slice(0);
    }
    refreshAttachments() {
      const t2 = this.document.getAttachments(), { added: e2, removed: i2 } = function() {
        let t3 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : [], e3 = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : [];
        const i3 = [], n2 = [], r2 = /* @__PURE__ */ new Set();
        t3.forEach((t4) => {
          r2.add(t4);
        });
        const o2 = /* @__PURE__ */ new Set();
        return e3.forEach((t4) => {
          o2.add(t4), r2.has(t4) || i3.push(t4);
        }), t3.forEach((t4) => {
          o2.has(t4) || n2.push(t4);
        }), { added: i3, removed: n2 };
      }(this.attachments, t2);
      return this.attachments = t2, Array.from(i2).forEach((t3) => {
        var e3, i3;
        t3.delegate = null, null === (e3 = this.delegate) || void 0 === e3 || null === (i3 = e3.compositionDidRemoveAttachment) || void 0 === i3 || i3.call(e3, t3);
      }), (() => {
        const t3 = [];
        return Array.from(e2).forEach((e3) => {
          var i3, n2;
          e3.delegate = this, t3.push(null === (i3 = this.delegate) || void 0 === i3 || null === (n2 = i3.compositionDidAddAttachment) || void 0 === n2 ? void 0 : n2.call(i3, e3));
        }), t3;
      })();
    }
    attachmentDidChangeAttributes(t2) {
      var e2, i2;
      return this.revision++, null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.compositionDidEditAttachment) || void 0 === i2 ? void 0 : i2.call(e2, t2);
    }
    attachmentDidChangePreviewURL(t2) {
      var e2, i2;
      return this.revision++, null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.compositionDidChangeAttachmentPreviewURL) || void 0 === i2 ? void 0 : i2.call(e2, t2);
    }
    editAttachment(t2, e2) {
      var i2, n2;
      if (t2 !== this.editingAttachment)
        return this.stopEditingAttachment(), this.editingAttachment = t2, null === (i2 = this.delegate) || void 0 === i2 || null === (n2 = i2.compositionDidStartEditingAttachment) || void 0 === n2 ? void 0 : n2.call(i2, this.editingAttachment, e2);
    }
    stopEditingAttachment() {
      var t2, e2;
      this.editingAttachment && (null === (t2 = this.delegate) || void 0 === t2 || null === (e2 = t2.compositionDidStopEditingAttachment) || void 0 === e2 || e2.call(t2, this.editingAttachment), this.editingAttachment = null);
    }
    updateAttributesForAttachment(t2, e2) {
      return this.setDocument(this.document.updateAttributesForAttachment(t2, e2));
    }
    removeAttributeForAttachment(t2, e2) {
      return this.setDocument(this.document.removeAttributeForAttachment(t2, e2));
    }
    breakFormattedBlock(t2) {
      let { document: e2 } = t2;
      const { block: i2 } = t2;
      let n2 = t2.startPosition, r2 = [n2 - 1, n2];
      i2.getBlockBreakPosition() === t2.startLocation.offset ? (i2.breaksOnReturn() && "\n" === t2.nextCharacter ? n2 += 1 : e2 = e2.removeTextAtRange(r2), r2 = [n2, n2]) : "\n" === t2.nextCharacter ? "\n" === t2.previousCharacter ? r2 = [n2 - 1, n2 + 1] : (r2 = [n2, n2 + 1], n2 += 1) : t2.startLocation.offset - 1 != 0 && (n2 += 1);
      const o2 = new Je([i2.removeLastAttribute().copyWithoutText()]);
      return this.setDocument(e2.insertDocumentAtRange(o2, r2)), this.setSelection(n2);
    }
    getPreviousBlock() {
      const t2 = this.getLocationRange();
      if (t2) {
        const { index: e2 } = t2[0];
        if (e2 > 0)
          return this.document.getBlockAtIndex(e2 - 1);
      }
    }
    getBlock() {
      const t2 = this.getLocationRange();
      if (t2)
        return this.document.getBlockAtIndex(t2[0].index);
    }
    getAttachmentAtRange(t2) {
      const e2 = this.document.getDocumentAtRange(t2);
      if (e2.toString() === "".concat("\uFFFC", "\n"))
        return e2.getAttachments()[0];
    }
    notifyDelegateOfCurrentAttributesChange() {
      var t2, e2;
      return null === (t2 = this.delegate) || void 0 === t2 || null === (e2 = t2.compositionDidChangeCurrentAttributes) || void 0 === e2 ? void 0 : e2.call(t2, this.currentAttributes);
    }
    notifyDelegateOfInsertionAtRange(t2) {
      var e2, i2;
      return null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.compositionDidPerformInsertionAtRange) || void 0 === i2 ? void 0 : i2.call(e2, t2);
    }
    translateUTF16PositionFromOffset(t2, e2) {
      const i2 = this.document.toUTF16String(), n2 = i2.offsetFromUCS2Offset(t2);
      return i2.offsetToUCS2Offset(n2 + e2);
    }
  };
  gi.proxyMethod("getSelectionManager().getPointRange"), gi.proxyMethod("getSelectionManager().setLocationRangeFromPointRange"), gi.proxyMethod("getSelectionManager().createLocationRangeFromDOMRange"), gi.proxyMethod("getSelectionManager().locationIsCursorTarget"), gi.proxyMethod("getSelectionManager().selectionIsExpanded"), gi.proxyMethod("delegate?.getSelectionManager");
  var mi = class extends H {
    constructor(t2) {
      super(...arguments), this.composition = t2, this.undoEntries = [], this.redoEntries = [];
    }
    recordUndoEntry(t2) {
      let { context: e2, consolidatable: i2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
      const n2 = this.undoEntries.slice(-1)[0];
      if (!i2 || !pi(n2, t2, e2)) {
        const i3 = this.createEntry({ description: t2, context: e2 });
        this.undoEntries.push(i3), this.redoEntries = [];
      }
    }
    undo() {
      const t2 = this.undoEntries.pop();
      if (t2) {
        const e2 = this.createEntry(t2);
        return this.redoEntries.push(e2), this.composition.loadSnapshot(t2.snapshot);
      }
    }
    redo() {
      const t2 = this.redoEntries.pop();
      if (t2) {
        const e2 = this.createEntry(t2);
        return this.undoEntries.push(e2), this.composition.loadSnapshot(t2.snapshot);
      }
    }
    canUndo() {
      return this.undoEntries.length > 0;
    }
    canRedo() {
      return this.redoEntries.length > 0;
    }
    createEntry() {
      let { description: t2, context: e2 } = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {};
      return { description: null == t2 ? void 0 : t2.toString(), context: JSON.stringify(e2), snapshot: this.composition.getSnapshot() };
    }
  };
  var pi = (t2, e2, i2) => (null == t2 ? void 0 : t2.description) === (null == e2 ? void 0 : e2.toString()) && (null == t2 ? void 0 : t2.context) === JSON.stringify(i2);
  var fi = "attachmentGallery";
  var bi = class {
    constructor(t2) {
      this.document = t2.document, this.selectedRange = t2.selectedRange;
    }
    perform() {
      return this.removeBlockAttribute(), this.applyBlockAttribute();
    }
    getSnapshot() {
      return { document: this.document, selectedRange: this.selectedRange };
    }
    removeBlockAttribute() {
      return this.findRangesOfBlocks().map((t2) => this.document = this.document.removeAttributeAtRange(fi, t2));
    }
    applyBlockAttribute() {
      let t2 = 0;
      this.findRangesOfPieces().forEach((e2) => {
        e2[1] - e2[0] > 1 && (e2[0] += t2, e2[1] += t2, "\n" !== this.document.getCharacterAtPosition(e2[1]) && (this.document = this.document.insertBlockBreakAtRange(e2[1]), e2[1] < this.selectedRange[1] && this.moveSelectedRangeForward(), e2[1]++, t2++), 0 !== e2[0] && "\n" !== this.document.getCharacterAtPosition(e2[0] - 1) && (this.document = this.document.insertBlockBreakAtRange(e2[0]), e2[0] < this.selectedRange[0] && this.moveSelectedRangeForward(), e2[0]++, t2++), this.document = this.document.applyBlockAttributeAtRange(fi, true, e2));
      });
    }
    findRangesOfBlocks() {
      return this.document.findRangesForBlockAttribute(fi);
    }
    findRangesOfPieces() {
      return this.document.findRangesForTextAttribute("presentation", { withValue: "gallery" });
    }
    moveSelectedRangeForward() {
      this.selectedRange[0] += 1, this.selectedRange[1] += 1;
    }
  };
  var vi = function(t2) {
    const e2 = new bi(t2);
    return e2.perform(), e2.getSnapshot();
  };
  var Ai = [vi];
  var xi = class {
    constructor(t2, e2, i2) {
      this.insertFiles = this.insertFiles.bind(this), this.composition = t2, this.selectionManager = e2, this.element = i2, this.undoManager = new mi(this.composition), this.filters = Ai.slice(0);
    }
    loadDocument(t2) {
      return this.loadSnapshot({ document: t2, selectedRange: [0, 0] });
    }
    loadHTML() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : "";
      const e2 = Xe.parse(t2, { referenceElement: this.element }).getDocument();
      return this.loadDocument(e2);
    }
    loadJSON(t2) {
      let { document: e2, selectedRange: i2 } = t2;
      return e2 = Je.fromJSON(e2), this.loadSnapshot({ document: e2, selectedRange: i2 });
    }
    loadSnapshot(t2) {
      return this.undoManager = new mi(this.composition), this.composition.loadSnapshot(t2);
    }
    getDocument() {
      return this.composition.document;
    }
    getSelectedDocument() {
      return this.composition.getSelectedDocument();
    }
    getSnapshot() {
      return this.composition.getSnapshot();
    }
    toJSON() {
      return this.getSnapshot();
    }
    deleteInDirection(t2) {
      return this.composition.deleteInDirection(t2);
    }
    insertAttachment(t2) {
      return this.composition.insertAttachment(t2);
    }
    insertAttachments(t2) {
      return this.composition.insertAttachments(t2);
    }
    insertDocument(t2) {
      return this.composition.insertDocument(t2);
    }
    insertFile(t2) {
      return this.composition.insertFile(t2);
    }
    insertFiles(t2) {
      return this.composition.insertFiles(t2);
    }
    insertHTML(t2) {
      return this.composition.insertHTML(t2);
    }
    insertString(t2) {
      return this.composition.insertString(t2);
    }
    insertText(t2) {
      return this.composition.insertText(t2);
    }
    insertLineBreak() {
      return this.composition.insertLineBreak();
    }
    getSelectedRange() {
      return this.composition.getSelectedRange();
    }
    getPosition() {
      return this.composition.getPosition();
    }
    getClientRectAtPosition(t2) {
      const e2 = this.getDocument().locationRangeFromRange([t2, t2 + 1]);
      return this.selectionManager.getClientRectAtLocationRange(e2);
    }
    expandSelectionInDirection(t2) {
      return this.composition.expandSelectionInDirection(t2);
    }
    moveCursorInDirection(t2) {
      return this.composition.moveCursorInDirection(t2);
    }
    setSelectedRange(t2) {
      return this.composition.setSelectedRange(t2);
    }
    activateAttribute(t2) {
      let e2 = !(arguments.length > 1 && void 0 !== arguments[1]) || arguments[1];
      return this.composition.setCurrentAttribute(t2, e2);
    }
    attributeIsActive(t2) {
      return this.composition.hasCurrentAttribute(t2);
    }
    canActivateAttribute(t2) {
      return this.composition.canSetCurrentAttribute(t2);
    }
    deactivateAttribute(t2) {
      return this.composition.removeCurrentAttribute(t2);
    }
    setHTMLAtributeAtPosition(t2, e2, i2) {
      this.composition.setHTMLAtributeAtPosition(t2, e2, i2);
    }
    canDecreaseNestingLevel() {
      return this.composition.canDecreaseNestingLevel();
    }
    canIncreaseNestingLevel() {
      return this.composition.canIncreaseNestingLevel();
    }
    decreaseNestingLevel() {
      if (this.canDecreaseNestingLevel())
        return this.composition.decreaseNestingLevel();
    }
    increaseNestingLevel() {
      if (this.canIncreaseNestingLevel())
        return this.composition.increaseNestingLevel();
    }
    canRedo() {
      return this.undoManager.canRedo();
    }
    canUndo() {
      return this.undoManager.canUndo();
    }
    recordUndoEntry(t2) {
      let { context: e2, consolidatable: i2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
      return this.undoManager.recordUndoEntry(t2, { context: e2, consolidatable: i2 });
    }
    redo() {
      if (this.canRedo())
        return this.undoManager.redo();
    }
    undo() {
      if (this.canUndo())
        return this.undoManager.undo();
    }
  };
  var yi = class {
    constructor(t2) {
      this.element = t2;
    }
    findLocationFromContainerAndOffset(t2, e2) {
      let { strict: i2 } = arguments.length > 2 && void 0 !== arguments[2] ? arguments[2] : { strict: true }, n2 = 0, r2 = false;
      const o2 = { index: 0, offset: 0 }, s2 = this.findAttachmentElementParentForNode(t2);
      s2 && (t2 = s2.parentNode, e2 = C(s2));
      const a2 = R(this.element, { usingFilter: Ei });
      for (; a2.nextNode(); ) {
        const s3 = a2.currentNode;
        if (s3 === t2 && O(t2)) {
          P(s3) || (o2.offset += e2);
          break;
        }
        if (s3.parentNode === t2) {
          if (n2++ === e2)
            break;
        } else if (!y(t2, s3) && n2 > 0)
          break;
        T(s3, { strict: i2 }) ? (r2 && o2.index++, o2.offset = 0, r2 = true) : o2.offset += Ci(s3);
      }
      return o2;
    }
    findContainerAndOffsetFromLocation(t2) {
      let e2, i2;
      if (0 === t2.index && 0 === t2.offset) {
        for (e2 = this.element, i2 = 0; e2.firstChild; )
          if (e2 = e2.firstChild, w(e2)) {
            i2 = 1;
            break;
          }
        return [e2, i2];
      }
      let [n2, r2] = this.findNodeAndOffsetFromLocation(t2);
      if (n2) {
        if (O(n2))
          0 === Ci(n2) ? (e2 = n2.parentNode.parentNode, i2 = C(n2.parentNode), P(n2, { name: "right" }) && i2++) : (e2 = n2, i2 = t2.offset - r2);
        else {
          if (e2 = n2.parentNode, !T(n2.previousSibling) && !w(e2))
            for (; n2 === e2.lastChild && (n2 = e2, e2 = e2.parentNode, !w(e2)); )
              ;
          i2 = C(n2), 0 !== t2.offset && i2++;
        }
        return [e2, i2];
      }
    }
    findNodeAndOffsetFromLocation(t2) {
      let e2, i2, n2 = 0;
      for (const r2 of this.getSignificantNodesForIndex(t2.index)) {
        const o2 = Ci(r2);
        if (t2.offset <= n2 + o2)
          if (O(r2)) {
            if (e2 = r2, i2 = n2, t2.offset === i2 && P(e2))
              break;
          } else
            e2 || (e2 = r2, i2 = n2);
        if (n2 += o2, n2 > t2.offset)
          break;
      }
      return [e2, i2];
    }
    findAttachmentElementParentForNode(t2) {
      for (; t2 && t2 !== this.element; ) {
        if (I(t2))
          return t2;
        t2 = t2.parentNode;
      }
    }
    getSignificantNodesForIndex(t2) {
      const e2 = [], i2 = R(this.element, { usingFilter: ki });
      let n2 = false;
      for (; i2.nextNode(); ) {
        const o2 = i2.currentNode;
        var r2;
        if (B(o2)) {
          if (null != r2 ? r2++ : r2 = 0, r2 === t2)
            n2 = true;
          else if (n2)
            break;
        } else
          n2 && e2.push(o2);
      }
      return e2;
    }
  };
  var Ci = function(t2) {
    if (t2.nodeType === Node.TEXT_NODE) {
      if (P(t2))
        return 0;
      return t2.textContent.length;
    }
    return "br" === E(t2) || I(t2) ? 1 : 0;
  };
  var ki = function(t2) {
    return Ri(t2) === NodeFilter.FILTER_ACCEPT ? Ei(t2) : NodeFilter.FILTER_REJECT;
  };
  var Ri = function(t2) {
    return N(t2) ? NodeFilter.FILTER_REJECT : NodeFilter.FILTER_ACCEPT;
  };
  var Ei = function(t2) {
    return I(t2.parentNode) ? NodeFilter.FILTER_REJECT : NodeFilter.FILTER_ACCEPT;
  };
  var Si = class {
    createDOMRangeFromPoint(t2) {
      let e2, { x: i2, y: n2 } = t2;
      if (document.caretPositionFromPoint) {
        const { offsetNode: t3, offset: r2 } = document.caretPositionFromPoint(i2, n2);
        return e2 = document.createRange(), e2.setStart(t3, r2), e2;
      }
      if (document.caretRangeFromPoint)
        return document.caretRangeFromPoint(i2, n2);
      if (document.body.createTextRange) {
        const t3 = Nt();
        try {
          const t4 = document.body.createTextRange();
          t4.moveToPoint(i2, n2), t4.select();
        } catch (t4) {
        }
        return e2 = Nt(), Ot(t3), e2;
      }
    }
    getClientRectsForDOMRange(t2) {
      const e2 = Array.from(t2.getClientRects());
      return [e2[0], e2[e2.length - 1]];
    }
  };
  var Li = class extends H {
    constructor(t2) {
      super(...arguments), this.didMouseDown = this.didMouseDown.bind(this), this.selectionDidChange = this.selectionDidChange.bind(this), this.element = t2, this.locationMapper = new yi(this.element), this.pointMapper = new Si(), this.lockCount = 0, f("mousedown", { onElement: this.element, withCallback: this.didMouseDown });
    }
    getLocationRange() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {};
      return false === t2.strict ? this.createLocationRangeFromDOMRange(Nt()) : t2.ignoreLock ? this.currentLocationRange : this.lockedLocationRange ? this.lockedLocationRange : this.currentLocationRange;
    }
    setLocationRange(t2) {
      if (this.lockedLocationRange)
        return;
      t2 = Lt(t2);
      const e2 = this.createDOMRangeFromLocationRange(t2);
      e2 && (Ot(e2), this.updateCurrentLocationRange(t2));
    }
    setLocationRangeFromPointRange(t2) {
      t2 = Lt(t2);
      const e2 = this.getLocationAtPoint(t2[0]), i2 = this.getLocationAtPoint(t2[1]);
      this.setLocationRange([e2, i2]);
    }
    getClientRectAtLocationRange(t2) {
      const e2 = this.createDOMRangeFromLocationRange(t2);
      if (e2)
        return this.getClientRectsForDOMRange(e2)[1];
    }
    locationIsCursorTarget(t2) {
      const e2 = Array.from(this.findNodeAndOffsetFromLocation(t2))[0];
      return P(e2);
    }
    lock() {
      0 == this.lockCount++ && (this.updateCurrentLocationRange(), this.lockedLocationRange = this.getLocationRange());
    }
    unlock() {
      if (0 == --this.lockCount) {
        const { lockedLocationRange: t2 } = this;
        if (this.lockedLocationRange = null, null != t2)
          return this.setLocationRange(t2);
      }
    }
    clearSelection() {
      var t2;
      return null === (t2 = It()) || void 0 === t2 ? void 0 : t2.removeAllRanges();
    }
    selectionIsCollapsed() {
      var t2;
      return true === (null === (t2 = Nt()) || void 0 === t2 ? void 0 : t2.collapsed);
    }
    selectionIsExpanded() {
      return !this.selectionIsCollapsed();
    }
    createLocationRangeFromDOMRange(t2, e2) {
      if (null == t2 || !this.domRangeWithinElement(t2))
        return;
      const i2 = this.findLocationFromContainerAndOffset(t2.startContainer, t2.startOffset, e2);
      if (!i2)
        return;
      const n2 = t2.collapsed ? void 0 : this.findLocationFromContainerAndOffset(t2.endContainer, t2.endOffset, e2);
      return Lt([i2, n2]);
    }
    didMouseDown() {
      return this.pauseTemporarily();
    }
    pauseTemporarily() {
      let t2;
      this.paused = true;
      const e2 = () => {
        if (this.paused = false, clearTimeout(i2), Array.from(t2).forEach((t3) => {
          t3.destroy();
        }), y(document, this.element))
          return this.selectionDidChange();
      }, i2 = setTimeout(e2, 200);
      t2 = ["mousemove", "keydown"].map((t3) => f(t3, { onElement: document, withCallback: e2 }));
    }
    selectionDidChange() {
      if (!this.paused && !x(this.element))
        return this.updateCurrentLocationRange();
    }
    updateCurrentLocationRange(t2) {
      var e2, i2;
      if ((null != t2 ? t2 : t2 = this.createLocationRangeFromDOMRange(Nt())) && !wt(t2, this.currentLocationRange))
        return this.currentLocationRange = t2, null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.locationRangeDidChange) || void 0 === i2 ? void 0 : i2.call(e2, this.currentLocationRange.slice(0));
    }
    createDOMRangeFromLocationRange(t2) {
      const e2 = this.findContainerAndOffsetFromLocation(t2[0]), i2 = Dt(t2) ? e2 : this.findContainerAndOffsetFromLocation(t2[1]) || e2;
      if (null != e2 && null != i2) {
        const t3 = document.createRange();
        return t3.setStart(...Array.from(e2 || [])), t3.setEnd(...Array.from(i2 || [])), t3;
      }
    }
    getLocationAtPoint(t2) {
      const e2 = this.createDOMRangeFromPoint(t2);
      var i2;
      if (e2)
        return null === (i2 = this.createLocationRangeFromDOMRange(e2)) || void 0 === i2 ? void 0 : i2[0];
    }
    domRangeWithinElement(t2) {
      return t2.collapsed ? y(this.element, t2.startContainer) : y(this.element, t2.startContainer) && y(this.element, t2.endContainer);
    }
  };
  Li.proxyMethod("locationMapper.findLocationFromContainerAndOffset"), Li.proxyMethod("locationMapper.findContainerAndOffsetFromLocation"), Li.proxyMethod("locationMapper.findNodeAndOffsetFromLocation"), Li.proxyMethod("pointMapper.createDOMRangeFromPoint"), Li.proxyMethod("pointMapper.getClientRectsForDOMRange");
  var Di = Object.freeze({ __proto__: null, Attachment: De, AttachmentManager: hi, AttachmentPiece: we, Block: Oe, Composition: gi, Document: Je, Editor: xi, HTMLParser: Xe, HTMLSanitizer: se, LineBreakInsertion: di, LocationMapper: yi, ManagedAttachment: ui, Piece: Se, PointMapper: Si, SelectionManager: Li, SplittableList: Be, StringPiece: Te, Text: Ne, UndoManager: mi });
  var wi = Object.freeze({ __proto__: null, ObjectView: ee, AttachmentView: ce, BlockView: be, DocumentView: ve, PieceView: ge, PreviewableAttachmentView: de, TextView: me });
  var { lang: Ti, css: Bi, keyNames: Fi } = V;
  var Pi = function(t2) {
    return function() {
      const e2 = t2.apply(this, arguments);
      e2.do(), this.undos || (this.undos = []), this.undos.push(e2.undo);
    };
  };
  var Ii = class extends H {
    constructor(t2, e2, i2) {
      let n2 = arguments.length > 3 && void 0 !== arguments[3] ? arguments[3] : {};
      super(...arguments), Re(this, "makeElementMutable", Pi(() => ({ do: () => {
        this.element.dataset.trixMutable = true;
      }, undo: () => delete this.element.dataset.trixMutable }))), Re(this, "addToolbar", Pi(() => {
        const t3 = S({ tagName: "div", className: Bi.attachmentToolbar, data: { trixMutable: true }, childNodes: S({ tagName: "div", className: "trix-button-row", childNodes: S({ tagName: "span", className: "trix-button-group trix-button-group--actions", childNodes: S({ tagName: "button", className: "trix-button trix-button--remove", textContent: Ti.remove, attributes: { title: Ti.remove }, data: { trixAction: "remove" } }) }) }) });
        return this.attachment.isPreviewable() && t3.appendChild(S({ tagName: "div", className: Bi.attachmentMetadataContainer, childNodes: S({ tagName: "span", className: Bi.attachmentMetadata, childNodes: [S({ tagName: "span", className: Bi.attachmentName, textContent: this.attachment.getFilename(), attributes: { title: this.attachment.getFilename() } }), S({ tagName: "span", className: Bi.attachmentSize, textContent: this.attachment.getFormattedFilesize() })] }) })), f("click", { onElement: t3, withCallback: this.didClickToolbar }), f("click", { onElement: t3, matchingSelector: "[data-trix-action]", withCallback: this.didClickActionButton }), b("trix-attachment-before-toolbar", { onElement: this.element, attributes: { toolbar: t3, attachment: this.attachment } }), { do: () => this.element.appendChild(t3), undo: () => k(t3) };
      })), Re(this, "installCaptionEditor", Pi(() => {
        const t3 = S({ tagName: "textarea", className: Bi.attachmentCaptionEditor, attributes: { placeholder: Ti.captionPlaceholder }, data: { trixMutable: true } });
        t3.value = this.attachmentPiece.getCaption();
        const e3 = t3.cloneNode();
        e3.classList.add("trix-autoresize-clone"), e3.tabIndex = -1;
        const i3 = function() {
          e3.value = t3.value, t3.style.height = e3.scrollHeight + "px";
        };
        f("input", { onElement: t3, withCallback: i3 }), f("input", { onElement: t3, withCallback: this.didInputCaption }), f("keydown", { onElement: t3, withCallback: this.didKeyDownCaption }), f("change", { onElement: t3, withCallback: this.didChangeCaption }), f("blur", { onElement: t3, withCallback: this.didBlurCaption });
        const n3 = this.element.querySelector("figcaption"), r2 = n3.cloneNode();
        return { do: () => {
          if (n3.style.display = "none", r2.appendChild(t3), r2.appendChild(e3), r2.classList.add("".concat(Bi.attachmentCaption, "--editing")), n3.parentElement.insertBefore(r2, n3), i3(), this.options.editCaption)
            return Rt(() => t3.focus());
        }, undo() {
          k(r2), n3.style.display = null;
        } };
      })), this.didClickToolbar = this.didClickToolbar.bind(this), this.didClickActionButton = this.didClickActionButton.bind(this), this.didKeyDownCaption = this.didKeyDownCaption.bind(this), this.didInputCaption = this.didInputCaption.bind(this), this.didChangeCaption = this.didChangeCaption.bind(this), this.didBlurCaption = this.didBlurCaption.bind(this), this.attachmentPiece = t2, this.element = e2, this.container = i2, this.options = n2, this.attachment = this.attachmentPiece.attachment, "a" === E(this.element) && (this.element = this.element.firstChild), this.install();
    }
    install() {
      this.makeElementMutable(), this.addToolbar(), this.attachment.isPreviewable() && this.installCaptionEditor();
    }
    uninstall() {
      var t2;
      let e2 = this.undos.pop();
      for (this.savePendingCaption(); e2; )
        e2(), e2 = this.undos.pop();
      null === (t2 = this.delegate) || void 0 === t2 || t2.didUninstallAttachmentEditor(this);
    }
    savePendingCaption() {
      if (null != this.pendingCaption) {
        const r2 = this.pendingCaption;
        var t2, e2, i2, n2;
        if (this.pendingCaption = null, r2)
          null === (t2 = this.delegate) || void 0 === t2 || null === (e2 = t2.attachmentEditorDidRequestUpdatingAttributesForAttachment) || void 0 === e2 || e2.call(t2, { caption: r2 }, this.attachment);
        else
          null === (i2 = this.delegate) || void 0 === i2 || null === (n2 = i2.attachmentEditorDidRequestRemovingAttributeForAttachment) || void 0 === n2 || n2.call(i2, "caption", this.attachment);
      }
    }
    didClickToolbar(t2) {
      return t2.preventDefault(), t2.stopPropagation();
    }
    didClickActionButton(t2) {
      var e2;
      if ("remove" === t2.target.getAttribute("data-trix-action"))
        return null === (e2 = this.delegate) || void 0 === e2 ? void 0 : e2.attachmentEditorDidRequestRemovalOfAttachment(this.attachment);
    }
    didKeyDownCaption(t2) {
      var e2, i2;
      if ("return" === Fi[t2.keyCode])
        return t2.preventDefault(), this.savePendingCaption(), null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.attachmentEditorDidRequestDeselectingAttachment) || void 0 === i2 ? void 0 : i2.call(e2, this.attachment);
    }
    didInputCaption(t2) {
      this.pendingCaption = t2.target.value.replace(/\s/g, " ").trim();
    }
    didChangeCaption(t2) {
      return this.savePendingCaption();
    }
    didBlurCaption(t2) {
      return this.savePendingCaption();
    }
  };
  var Ni = class extends H {
    constructor(t2, i2) {
      super(...arguments), this.didFocus = this.didFocus.bind(this), this.didBlur = this.didBlur.bind(this), this.didClickAttachment = this.didClickAttachment.bind(this), this.element = t2, this.composition = i2, this.documentView = new ve(this.composition.document, { element: this.element }), f("focus", { onElement: this.element, withCallback: this.didFocus }), f("blur", { onElement: this.element, withCallback: this.didBlur }), f("click", { onElement: this.element, matchingSelector: "a[contenteditable=false]", preventDefault: true }), f("mousedown", { onElement: this.element, matchingSelector: e, withCallback: this.didClickAttachment }), f("click", { onElement: this.element, matchingSelector: "a".concat(e), preventDefault: true });
    }
    didFocus(t2) {
      var e2;
      const i2 = () => {
        var t3, e3;
        if (!this.focused)
          return this.focused = true, null === (t3 = this.delegate) || void 0 === t3 || null === (e3 = t3.compositionControllerDidFocus) || void 0 === e3 ? void 0 : e3.call(t3);
      };
      return (null === (e2 = this.blurPromise) || void 0 === e2 ? void 0 : e2.then(i2)) || i2();
    }
    didBlur(t2) {
      this.blurPromise = new Promise((t3) => Rt(() => {
        var e2, i2;
        x(this.element) || (this.focused = null, null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.compositionControllerDidBlur) || void 0 === i2 || i2.call(e2));
        return this.blurPromise = null, t3();
      }));
    }
    didClickAttachment(t2, e2) {
      var i2, n2;
      const r2 = this.findAttachmentForElement(e2), o2 = !!A(t2.target, { matchingSelector: "figcaption" });
      return null === (i2 = this.delegate) || void 0 === i2 || null === (n2 = i2.compositionControllerDidSelectAttachment) || void 0 === n2 ? void 0 : n2.call(i2, r2, { editCaption: o2 });
    }
    getSerializableElement() {
      return this.isEditingAttachment() ? this.documentView.shadowElement : this.element;
    }
    render() {
      var t2, e2, i2, n2, r2, o2;
      (this.revision !== this.composition.revision && (this.documentView.setDocument(this.composition.document), this.documentView.render(), this.revision = this.composition.revision), this.canSyncDocumentView() && !this.documentView.isSynced()) && (null === (i2 = this.delegate) || void 0 === i2 || null === (n2 = i2.compositionControllerWillSyncDocumentView) || void 0 === n2 || n2.call(i2), this.documentView.sync(), null === (r2 = this.delegate) || void 0 === r2 || null === (o2 = r2.compositionControllerDidSyncDocumentView) || void 0 === o2 || o2.call(r2));
      return null === (t2 = this.delegate) || void 0 === t2 || null === (e2 = t2.compositionControllerDidRender) || void 0 === e2 ? void 0 : e2.call(t2);
    }
    rerenderViewForObject(t2) {
      return this.invalidateViewForObject(t2), this.render();
    }
    invalidateViewForObject(t2) {
      return this.documentView.invalidateViewForObject(t2);
    }
    isViewCachingEnabled() {
      return this.documentView.isViewCachingEnabled();
    }
    enableViewCaching() {
      return this.documentView.enableViewCaching();
    }
    disableViewCaching() {
      return this.documentView.disableViewCaching();
    }
    refreshViewCache() {
      return this.documentView.garbageCollectCachedViews();
    }
    isEditingAttachment() {
      return !!this.attachmentEditor;
    }
    installAttachmentEditorForAttachment(t2, e2) {
      var i2;
      if ((null === (i2 = this.attachmentEditor) || void 0 === i2 ? void 0 : i2.attachment) === t2)
        return;
      const n2 = this.documentView.findElementForObject(t2);
      if (!n2)
        return;
      this.uninstallAttachmentEditor();
      const r2 = this.composition.document.getAttachmentPieceForAttachment(t2);
      this.attachmentEditor = new Ii(r2, n2, this.element, e2), this.attachmentEditor.delegate = this;
    }
    uninstallAttachmentEditor() {
      var t2;
      return null === (t2 = this.attachmentEditor) || void 0 === t2 ? void 0 : t2.uninstall();
    }
    didUninstallAttachmentEditor() {
      return this.attachmentEditor = null, this.render();
    }
    attachmentEditorDidRequestUpdatingAttributesForAttachment(t2, e2) {
      var i2, n2;
      return null === (i2 = this.delegate) || void 0 === i2 || null === (n2 = i2.compositionControllerWillUpdateAttachment) || void 0 === n2 || n2.call(i2, e2), this.composition.updateAttributesForAttachment(t2, e2);
    }
    attachmentEditorDidRequestRemovingAttributeForAttachment(t2, e2) {
      var i2, n2;
      return null === (i2 = this.delegate) || void 0 === i2 || null === (n2 = i2.compositionControllerWillUpdateAttachment) || void 0 === n2 || n2.call(i2, e2), this.composition.removeAttributeForAttachment(t2, e2);
    }
    attachmentEditorDidRequestRemovalOfAttachment(t2) {
      var e2, i2;
      return null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.compositionControllerDidRequestRemovalOfAttachment) || void 0 === i2 ? void 0 : i2.call(e2, t2);
    }
    attachmentEditorDidRequestDeselectingAttachment(t2) {
      var e2, i2;
      return null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.compositionControllerDidRequestDeselectingAttachment) || void 0 === i2 ? void 0 : i2.call(e2, t2);
    }
    canSyncDocumentView() {
      return !this.isEditingAttachment();
    }
    findAttachmentForElement(t2) {
      return this.composition.document.getAttachmentById(parseInt(t2.dataset.trixId, 10));
    }
  };
  var Oi = class extends H {
  };
  var Mi = "data-trix-mutable";
  var ji = "[".concat(Mi, "]");
  var Wi = { attributes: true, childList: true, characterData: true, characterDataOldValue: true, subtree: true };
  var Ui = class extends H {
    constructor(t2) {
      super(t2), this.didMutate = this.didMutate.bind(this), this.element = t2, this.observer = new window.MutationObserver(this.didMutate), this.start();
    }
    start() {
      return this.reset(), this.observer.observe(this.element, Wi);
    }
    stop() {
      return this.observer.disconnect();
    }
    didMutate(t2) {
      var e2, i2;
      if (this.mutations.push(...Array.from(this.findSignificantMutations(t2) || [])), this.mutations.length)
        return null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.elementDidMutate) || void 0 === i2 || i2.call(e2, this.getMutationSummary()), this.reset();
    }
    reset() {
      this.mutations = [];
    }
    findSignificantMutations(t2) {
      return t2.filter((t3) => this.mutationIsSignificant(t3));
    }
    mutationIsSignificant(t2) {
      if (this.nodeIsMutable(t2.target))
        return false;
      for (const e2 of Array.from(this.nodesModifiedByMutation(t2)))
        if (this.nodeIsSignificant(e2))
          return true;
      return false;
    }
    nodeIsSignificant(t2) {
      return t2 !== this.element && !this.nodeIsMutable(t2) && !N(t2);
    }
    nodeIsMutable(t2) {
      return A(t2, { matchingSelector: ji });
    }
    nodesModifiedByMutation(t2) {
      const e2 = [];
      switch (t2.type) {
        case "attributes":
          t2.attributeName !== Mi && e2.push(t2.target);
          break;
        case "characterData":
          e2.push(t2.target.parentNode), e2.push(t2.target);
          break;
        case "childList":
          e2.push(...Array.from(t2.addedNodes || [])), e2.push(...Array.from(t2.removedNodes || []));
      }
      return e2;
    }
    getMutationSummary() {
      return this.getTextMutationSummary();
    }
    getTextMutationSummary() {
      const { additions: t2, deletions: e2 } = this.getTextChangesFromCharacterData(), i2 = this.getTextChangesFromChildList();
      Array.from(i2.additions).forEach((e3) => {
        Array.from(t2).includes(e3) || t2.push(e3);
      }), e2.push(...Array.from(i2.deletions || []));
      const n2 = {}, r2 = t2.join("");
      r2 && (n2.textAdded = r2);
      const o2 = e2.join("");
      return o2 && (n2.textDeleted = o2), n2;
    }
    getMutationsByType(t2) {
      return Array.from(this.mutations).filter((e2) => e2.type === t2);
    }
    getTextChangesFromChildList() {
      let t2, e2;
      const i2 = [], n2 = [];
      Array.from(this.getMutationsByType("childList")).forEach((t3) => {
        i2.push(...Array.from(t3.addedNodes || [])), n2.push(...Array.from(t3.removedNodes || []));
      });
      0 === i2.length && 1 === n2.length && B(n2[0]) ? (t2 = [], e2 = ["\n"]) : (t2 = qi(i2), e2 = qi(n2));
      return { additions: t2.filter((t3, i3) => t3 !== e2[i3]).map(Wt), deletions: e2.filter((e3, i3) => e3 !== t2[i3]).map(Wt) };
    }
    getTextChangesFromCharacterData() {
      let t2, e2;
      const i2 = this.getMutationsByType("characterData");
      if (i2.length) {
        const n2 = i2[0], r2 = i2[i2.length - 1], o2 = function(t3, e3) {
          let i3, n3;
          return t3 = X.box(t3), (e3 = X.box(e3)).length < t3.length ? [n3, i3] = Vt(t3, e3) : [i3, n3] = Vt(e3, t3), { added: i3, removed: n3 };
        }(Wt(n2.oldValue), Wt(r2.target.data));
        t2 = o2.added, e2 = o2.removed;
      }
      return { additions: t2 ? [t2] : [], deletions: e2 ? [e2] : [] };
    }
  };
  var qi = function() {
    let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : [];
    const e2 = [];
    for (const i2 of Array.from(t2))
      switch (i2.nodeType) {
        case Node.TEXT_NODE:
          e2.push(i2.data);
          break;
        case Node.ELEMENT_NODE:
          "br" === E(i2) ? e2.push("\n") : e2.push(...Array.from(qi(i2.childNodes) || []));
      }
    return e2;
  };
  var Vi = class extends te {
    constructor(t2) {
      super(...arguments), this.file = t2;
    }
    perform(t2) {
      const e2 = new FileReader();
      return e2.onerror = () => t2(false), e2.onload = () => {
        e2.onerror = null;
        try {
          e2.abort();
        } catch (t3) {
        }
        return t2(true, this.file);
      }, e2.readAsArrayBuffer(this.file);
    }
  };
  var Hi = class {
    constructor(t2) {
      this.element = t2;
    }
    shouldIgnore(t2) {
      return !!a.samsungAndroid && (this.previousEvent = this.event, this.event = t2, this.checkSamsungKeyboardBuggyModeStart(), this.checkSamsungKeyboardBuggyModeEnd(), this.buggyMode);
    }
    checkSamsungKeyboardBuggyModeStart() {
      this.insertingLongTextAfterUnidentifiedChar() && zi(this.element.innerText, this.event.data) && (this.buggyMode = true, this.event.preventDefault());
    }
    checkSamsungKeyboardBuggyModeEnd() {
      this.buggyMode && "insertText" !== this.event.inputType && (this.buggyMode = false);
    }
    insertingLongTextAfterUnidentifiedChar() {
      var t2;
      return this.isBeforeInputInsertText() && this.previousEventWasUnidentifiedKeydown() && (null === (t2 = this.event.data) || void 0 === t2 ? void 0 : t2.length) > 50;
    }
    isBeforeInputInsertText() {
      return "beforeinput" === this.event.type && "insertText" === this.event.inputType;
    }
    previousEventWasUnidentifiedKeydown() {
      var t2, e2;
      return "keydown" === (null === (t2 = this.previousEvent) || void 0 === t2 ? void 0 : t2.type) && "Unidentified" === (null === (e2 = this.previousEvent) || void 0 === e2 ? void 0 : e2.key);
    }
  };
  var zi = (t2, e2) => Ji(t2) === Ji(e2);
  var _i = new RegExp("(".concat("\uFFFC", "|").concat(h, "|").concat(d, "|\\s)+"), "g");
  var Ji = (t2) => t2.replace(_i, " ").trim();
  var Ki = class extends H {
    constructor(t2) {
      super(...arguments), this.element = t2, this.mutationObserver = new Ui(this.element), this.mutationObserver.delegate = this, this.flakyKeyboardDetector = new Hi(this.element);
      for (const t3 in this.constructor.events)
        f(t3, { onElement: this.element, withCallback: this.handlerFor(t3) });
    }
    elementDidMutate(t2) {
    }
    editorWillSyncDocumentView() {
      return this.mutationObserver.stop();
    }
    editorDidSyncDocumentView() {
      return this.mutationObserver.start();
    }
    requestRender() {
      var t2, e2;
      return null === (t2 = this.delegate) || void 0 === t2 || null === (e2 = t2.inputControllerDidRequestRender) || void 0 === e2 ? void 0 : e2.call(t2);
    }
    requestReparse() {
      var t2, e2;
      return null === (t2 = this.delegate) || void 0 === t2 || null === (e2 = t2.inputControllerDidRequestReparse) || void 0 === e2 || e2.call(t2), this.requestRender();
    }
    attachFiles(t2) {
      const e2 = Array.from(t2).map((t3) => new Vi(t3));
      return Promise.all(e2).then((t3) => {
        this.handleInput(function() {
          var e3, i2;
          return null === (e3 = this.delegate) || void 0 === e3 || e3.inputControllerWillAttachFiles(), null === (i2 = this.responder) || void 0 === i2 || i2.insertFiles(t3), this.requestRender();
        });
      });
    }
    handlerFor(t2) {
      return (e2) => {
        e2.defaultPrevented || this.handleInput(() => {
          if (!x(this.element)) {
            if (this.flakyKeyboardDetector.shouldIgnore(e2))
              return;
            this.eventName = t2, this.constructor.events[t2].call(this, e2);
          }
        });
      };
    }
    handleInput(t2) {
      try {
        var e2;
        null === (e2 = this.delegate) || void 0 === e2 || e2.inputControllerWillHandleInput(), t2.call(this);
      } finally {
        var i2;
        null === (i2 = this.delegate) || void 0 === i2 || i2.inputControllerDidHandleInput();
      }
    }
    createLinkHTML(t2, e2) {
      const i2 = document.createElement("a");
      return i2.href = t2, i2.textContent = e2 || t2, i2.outerHTML;
    }
  };
  var Gi;
  Re(Ki, "events", {});
  var { browser: $i, keyNames: Xi } = V;
  var Yi = 0;
  var Qi = class extends Ki {
    constructor() {
      super(...arguments), this.resetInputSummary();
    }
    setInputSummary() {
      let t2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : {};
      this.inputSummary.eventName = this.eventName;
      for (const e2 in t2) {
        const i2 = t2[e2];
        this.inputSummary[e2] = i2;
      }
      return this.inputSummary;
    }
    resetInputSummary() {
      this.inputSummary = {};
    }
    reset() {
      return this.resetInputSummary(), Pt.reset();
    }
    elementDidMutate(t2) {
      var e2, i2;
      return this.isComposing() ? null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.inputControllerDidAllowUnhandledInput) || void 0 === i2 ? void 0 : i2.call(e2) : this.handleInput(function() {
        return this.mutationIsSignificant(t2) && (this.mutationIsExpected(t2) ? this.requestRender() : this.requestReparse()), this.reset();
      });
    }
    mutationIsExpected(t2) {
      let { textAdded: e2, textDeleted: i2 } = t2;
      if (this.inputSummary.preferDocument)
        return true;
      const n2 = null != e2 ? e2 === this.inputSummary.textAdded : !this.inputSummary.textAdded, r2 = null != i2 ? this.inputSummary.didDelete : !this.inputSummary.didDelete, o2 = ["\n", " \n"].includes(e2) && !n2, s2 = "\n" === i2 && !r2;
      if (o2 && !s2 || s2 && !o2) {
        const t3 = this.getSelectedRange();
        if (t3) {
          var a2;
          const i3 = o2 ? e2.replace(/\n$/, "").length || -1 : (null == e2 ? void 0 : e2.length) || 1;
          if (null !== (a2 = this.responder) && void 0 !== a2 && a2.positionIsBlockBreak(t3[1] + i3))
            return true;
        }
      }
      return n2 && r2;
    }
    mutationIsSignificant(t2) {
      var e2;
      const i2 = Object.keys(t2).length > 0, n2 = "" === (null === (e2 = this.compositionInput) || void 0 === e2 ? void 0 : e2.getEndData());
      return i2 || !n2;
    }
    getCompositionInput() {
      if (this.isComposing())
        return this.compositionInput;
      this.compositionInput = new rn(this);
    }
    isComposing() {
      return this.compositionInput && !this.compositionInput.isEnded();
    }
    deleteInDirection(t2, e2) {
      var i2;
      return false !== (null === (i2 = this.responder) || void 0 === i2 ? void 0 : i2.deleteInDirection(t2)) ? this.setInputSummary({ didDelete: true }) : e2 ? (e2.preventDefault(), this.requestRender()) : void 0;
    }
    serializeSelectionToDataTransfer(t2) {
      var e2;
      if (!function(t3) {
        if (null == t3 || !t3.setData)
          return false;
        for (const e3 in yt) {
          const i3 = yt[e3];
          try {
            if (t3.setData(e3, i3), !t3.getData(e3) === i3)
              return false;
          } catch (t4) {
            return false;
          }
        }
        return true;
      }(t2))
        return;
      const i2 = null === (e2 = this.responder) || void 0 === e2 ? void 0 : e2.getSelectedDocument().toSerializableDocument();
      return t2.setData("application/x-trix-document", JSON.stringify(i2)), t2.setData("text/html", ve.render(i2).innerHTML), t2.setData("text/plain", i2.toString().replace(/\n$/, "")), true;
    }
    canAcceptDataTransfer(t2) {
      const e2 = {};
      return Array.from((null == t2 ? void 0 : t2.types) || []).forEach((t3) => {
        e2[t3] = true;
      }), e2.Files || e2["application/x-trix-document"] || e2["text/html"] || e2["text/plain"];
    }
    getPastedHTMLUsingHiddenElement(t2) {
      const e2 = this.getSelectedRange(), i2 = { position: "absolute", left: "".concat(window.pageXOffset, "px"), top: "".concat(window.pageYOffset, "px"), opacity: 0 }, n2 = S({ style: i2, tagName: "div", editable: true });
      return document.body.appendChild(n2), n2.focus(), requestAnimationFrame(() => {
        const i3 = n2.innerHTML;
        return k(n2), this.setSelectedRange(e2), t2(i3);
      });
    }
  };
  Re(Qi, "events", { keydown(t2) {
    this.isComposing() || this.resetInputSummary(), this.inputSummary.didInput = true;
    const e2 = Xi[t2.keyCode];
    if (e2) {
      var i2;
      let n3 = this.keys;
      ["ctrl", "alt", "shift", "meta"].forEach((e3) => {
        var i3;
        t2["".concat(e3, "Key")] && ("ctrl" === e3 && (e3 = "control"), n3 = null === (i3 = n3) || void 0 === i3 ? void 0 : i3[e3]);
      }), null != (null === (i2 = n3) || void 0 === i2 ? void 0 : i2[e2]) && (this.setInputSummary({ keyName: e2 }), Pt.reset(), n3[e2].call(this, t2));
    }
    if (kt(t2)) {
      const e3 = String.fromCharCode(t2.keyCode).toLowerCase();
      if (e3) {
        var n2;
        const i3 = ["alt", "shift"].map((e4) => {
          if (t2["".concat(e4, "Key")])
            return e4;
        }).filter((t3) => t3);
        i3.push(e3), null !== (n2 = this.delegate) && void 0 !== n2 && n2.inputControllerDidReceiveKeyboardCommand(i3) && t2.preventDefault();
      }
    }
  }, keypress(t2) {
    if (null != this.inputSummary.eventName)
      return;
    if (t2.metaKey)
      return;
    if (t2.ctrlKey && !t2.altKey)
      return;
    const e2 = en(t2);
    var i2, n2;
    return e2 ? (null === (i2 = this.delegate) || void 0 === i2 || i2.inputControllerWillPerformTyping(), null === (n2 = this.responder) || void 0 === n2 || n2.insertString(e2), this.setInputSummary({ textAdded: e2, didDelete: this.selectionIsExpanded() })) : void 0;
  }, textInput(t2) {
    const { data: e2 } = t2, { textAdded: i2 } = this.inputSummary;
    if (i2 && i2 !== e2 && i2.toUpperCase() === e2) {
      var n2;
      const t3 = this.getSelectedRange();
      return this.setSelectedRange([t3[0], t3[1] + i2.length]), null === (n2 = this.responder) || void 0 === n2 || n2.insertString(e2), this.setInputSummary({ textAdded: e2 }), this.setSelectedRange(t3);
    }
  }, dragenter(t2) {
    t2.preventDefault();
  }, dragstart(t2) {
    var e2, i2;
    return this.serializeSelectionToDataTransfer(t2.dataTransfer), this.draggedRange = this.getSelectedRange(), null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.inputControllerDidStartDrag) || void 0 === i2 ? void 0 : i2.call(e2);
  }, dragover(t2) {
    if (this.draggedRange || this.canAcceptDataTransfer(t2.dataTransfer)) {
      t2.preventDefault();
      const n2 = { x: t2.clientX, y: t2.clientY };
      var e2, i2;
      if (!St(n2, this.draggingPoint))
        return this.draggingPoint = n2, null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.inputControllerDidReceiveDragOverPoint) || void 0 === i2 ? void 0 : i2.call(e2, this.draggingPoint);
    }
  }, dragend(t2) {
    var e2, i2;
    null === (e2 = this.delegate) || void 0 === e2 || null === (i2 = e2.inputControllerDidCancelDrag) || void 0 === i2 || i2.call(e2), this.draggedRange = null, this.draggingPoint = null;
  }, drop(t2) {
    var e2, i2;
    t2.preventDefault();
    const n2 = null === (e2 = t2.dataTransfer) || void 0 === e2 ? void 0 : e2.files, r2 = t2.dataTransfer.getData("application/x-trix-document"), o2 = { x: t2.clientX, y: t2.clientY };
    if (null === (i2 = this.responder) || void 0 === i2 || i2.setLocationRangeFromPointRange(o2), null != n2 && n2.length)
      this.attachFiles(n2);
    else if (this.draggedRange) {
      var s2, a2;
      null === (s2 = this.delegate) || void 0 === s2 || s2.inputControllerWillMoveText(), null === (a2 = this.responder) || void 0 === a2 || a2.moveTextFromRange(this.draggedRange), this.draggedRange = null, this.requestRender();
    } else if (r2) {
      var l2;
      const t3 = Je.fromJSONString(r2);
      null === (l2 = this.responder) || void 0 === l2 || l2.insertDocument(t3), this.requestRender();
    }
    this.draggedRange = null, this.draggingPoint = null;
  }, cut(t2) {
    var e2, i2;
    if (null !== (e2 = this.responder) && void 0 !== e2 && e2.selectionIsExpanded() && (this.serializeSelectionToDataTransfer(t2.clipboardData) && t2.preventDefault(), null === (i2 = this.delegate) || void 0 === i2 || i2.inputControllerWillCutText(), this.deleteInDirection("backward"), t2.defaultPrevented))
      return this.requestRender();
  }, copy(t2) {
    var e2;
    null !== (e2 = this.responder) && void 0 !== e2 && e2.selectionIsExpanded() && this.serializeSelectionToDataTransfer(t2.clipboardData) && t2.preventDefault();
  }, paste(t2) {
    const e2 = t2.clipboardData || t2.testClipboardData, i2 = { clipboard: e2 };
    if (!e2 || nn(t2))
      return void this.getPastedHTMLUsingHiddenElement((t3) => {
        var e3, n3, r3;
        return i2.type = "text/html", i2.html = t3, null === (e3 = this.delegate) || void 0 === e3 || e3.inputControllerWillPaste(i2), null === (n3 = this.responder) || void 0 === n3 || n3.insertHTML(i2.html), this.requestRender(), null === (r3 = this.delegate) || void 0 === r3 ? void 0 : r3.inputControllerDidPaste(i2);
      });
    const n2 = e2.getData("URL"), r2 = e2.getData("text/html"), o2 = e2.getData("public.url-name");
    if (n2) {
      var s2, a2, l2;
      let t3;
      i2.type = "text/html", t3 = o2 ? qt(o2).trim() : n2, i2.html = this.createLinkHTML(n2, t3), null === (s2 = this.delegate) || void 0 === s2 || s2.inputControllerWillPaste(i2), this.setInputSummary({ textAdded: t3, didDelete: this.selectionIsExpanded() }), null === (a2 = this.responder) || void 0 === a2 || a2.insertHTML(i2.html), this.requestRender(), null === (l2 = this.delegate) || void 0 === l2 || l2.inputControllerDidPaste(i2);
    } else if (Ct(e2)) {
      var c2, u2, h2;
      i2.type = "text/plain", i2.string = e2.getData("text/plain"), null === (c2 = this.delegate) || void 0 === c2 || c2.inputControllerWillPaste(i2), this.setInputSummary({ textAdded: i2.string, didDelete: this.selectionIsExpanded() }), null === (u2 = this.responder) || void 0 === u2 || u2.insertString(i2.string), this.requestRender(), null === (h2 = this.delegate) || void 0 === h2 || h2.inputControllerDidPaste(i2);
    } else if (r2) {
      var d2, g2, m2;
      i2.type = "text/html", i2.html = r2, null === (d2 = this.delegate) || void 0 === d2 || d2.inputControllerWillPaste(i2), null === (g2 = this.responder) || void 0 === g2 || g2.insertHTML(i2.html), this.requestRender(), null === (m2 = this.delegate) || void 0 === m2 || m2.inputControllerDidPaste(i2);
    } else if (Array.from(e2.types).includes("Files")) {
      var p2, f2;
      const t3 = null === (p2 = e2.items) || void 0 === p2 || null === (p2 = p2[0]) || void 0 === p2 || null === (f2 = p2.getAsFile) || void 0 === f2 ? void 0 : f2.call(p2);
      if (t3) {
        var b2, v2, A2;
        const e3 = Zi(t3);
        !t3.name && e3 && (t3.name = "pasted-file-".concat(++Yi, ".").concat(e3)), i2.type = "File", i2.file = t3, null === (b2 = this.delegate) || void 0 === b2 || b2.inputControllerWillAttachFiles(), null === (v2 = this.responder) || void 0 === v2 || v2.insertFile(i2.file), this.requestRender(), null === (A2 = this.delegate) || void 0 === A2 || A2.inputControllerDidPaste(i2);
      }
    }
    t2.preventDefault();
  }, compositionstart(t2) {
    return this.getCompositionInput().start(t2.data);
  }, compositionupdate(t2) {
    return this.getCompositionInput().update(t2.data);
  }, compositionend(t2) {
    return this.getCompositionInput().end(t2.data);
  }, beforeinput(t2) {
    this.inputSummary.didInput = true;
  }, input(t2) {
    return this.inputSummary.didInput = true, t2.stopPropagation();
  } }), Re(Qi, "keys", { backspace(t2) {
    var e2;
    return null === (e2 = this.delegate) || void 0 === e2 || e2.inputControllerWillPerformTyping(), this.deleteInDirection("backward", t2);
  }, delete(t2) {
    var e2;
    return null === (e2 = this.delegate) || void 0 === e2 || e2.inputControllerWillPerformTyping(), this.deleteInDirection("forward", t2);
  }, return(t2) {
    var e2, i2;
    return this.setInputSummary({ preferDocument: true }), null === (e2 = this.delegate) || void 0 === e2 || e2.inputControllerWillPerformTyping(), null === (i2 = this.responder) || void 0 === i2 ? void 0 : i2.insertLineBreak();
  }, tab(t2) {
    var e2, i2;
    null !== (e2 = this.responder) && void 0 !== e2 && e2.canIncreaseNestingLevel() && (null === (i2 = this.responder) || void 0 === i2 || i2.increaseNestingLevel(), this.requestRender(), t2.preventDefault());
  }, left(t2) {
    var e2;
    if (this.selectionIsInCursorTarget())
      return t2.preventDefault(), null === (e2 = this.responder) || void 0 === e2 ? void 0 : e2.moveCursorInDirection("backward");
  }, right(t2) {
    var e2;
    if (this.selectionIsInCursorTarget())
      return t2.preventDefault(), null === (e2 = this.responder) || void 0 === e2 ? void 0 : e2.moveCursorInDirection("forward");
  }, control: { d(t2) {
    var e2;
    return null === (e2 = this.delegate) || void 0 === e2 || e2.inputControllerWillPerformTyping(), this.deleteInDirection("forward", t2);
  }, h(t2) {
    var e2;
    return null === (e2 = this.delegate) || void 0 === e2 || e2.inputControllerWillPerformTyping(), this.deleteInDirection("backward", t2);
  }, o(t2) {
    var e2, i2;
    return t2.preventDefault(), null === (e2 = this.delegate) || void 0 === e2 || e2.inputControllerWillPerformTyping(), null === (i2 = this.responder) || void 0 === i2 || i2.insertString("\n", { updatePosition: false }), this.requestRender();
  } }, shift: { return(t2) {
    var e2, i2;
    null === (e2 = this.delegate) || void 0 === e2 || e2.inputControllerWillPerformTyping(), null === (i2 = this.responder) || void 0 === i2 || i2.insertString("\n"), this.requestRender(), t2.preventDefault();
  }, tab(t2) {
    var e2, i2;
    null !== (e2 = this.responder) && void 0 !== e2 && e2.canDecreaseNestingLevel() && (null === (i2 = this.responder) || void 0 === i2 || i2.decreaseNestingLevel(), this.requestRender(), t2.preventDefault());
  }, left(t2) {
    if (this.selectionIsInCursorTarget())
      return t2.preventDefault(), this.expandSelectionInDirection("backward");
  }, right(t2) {
    if (this.selectionIsInCursorTarget())
      return t2.preventDefault(), this.expandSelectionInDirection("forward");
  } }, alt: { backspace(t2) {
    var e2;
    return this.setInputSummary({ preferDocument: false }), null === (e2 = this.delegate) || void 0 === e2 ? void 0 : e2.inputControllerWillPerformTyping();
  } }, meta: { backspace(t2) {
    var e2;
    return this.setInputSummary({ preferDocument: false }), null === (e2 = this.delegate) || void 0 === e2 ? void 0 : e2.inputControllerWillPerformTyping();
  } } }), Qi.proxyMethod("responder?.getSelectedRange"), Qi.proxyMethod("responder?.setSelectedRange"), Qi.proxyMethod("responder?.expandSelectionInDirection"), Qi.proxyMethod("responder?.selectionIsInCursorTarget"), Qi.proxyMethod("responder?.selectionIsExpanded");
  var Zi = (t2) => {
    var e2;
    return null === (e2 = t2.type) || void 0 === e2 || null === (e2 = e2.match(/\/(\w+)$/)) || void 0 === e2 ? void 0 : e2[1];
  };
  var tn = !(null === (Gi = " ".codePointAt) || void 0 === Gi || !Gi.call(" ", 0));
  var en = function(t2) {
    if (t2.key && tn && t2.key.codePointAt(0) === t2.keyCode)
      return t2.key;
    {
      let e2;
      if (null === t2.which ? e2 = t2.keyCode : 0 !== t2.which && 0 !== t2.charCode && (e2 = t2.charCode), null != e2 && "escape" !== Xi[e2])
        return X.fromCodepoints([e2]).toString();
    }
  };
  var nn = function(t2) {
    const e2 = t2.clipboardData;
    if (e2) {
      if (e2.types.includes("text/html")) {
        for (const t3 of e2.types) {
          const i2 = /^CorePasteboardFlavorType/.test(t3), n2 = /^dyn\./.test(t3) && e2.getData(t3);
          if (i2 || n2)
            return true;
        }
        return false;
      }
      {
        const t3 = e2.types.includes("com.apple.webarchive"), i2 = e2.types.includes("com.apple.flat-rtfd");
        return t3 || i2;
      }
    }
  };
  var rn = class extends H {
    constructor(t2) {
      super(...arguments), this.inputController = t2, this.responder = this.inputController.responder, this.delegate = this.inputController.delegate, this.inputSummary = this.inputController.inputSummary, this.data = {};
    }
    start(t2) {
      if (this.data.start = t2, this.isSignificant()) {
        var e2, i2;
        if ("keypress" === this.inputSummary.eventName && this.inputSummary.textAdded)
          null === (i2 = this.responder) || void 0 === i2 || i2.deleteInDirection("left");
        this.selectionIsExpanded() || (this.insertPlaceholder(), this.requestRender()), this.range = null === (e2 = this.responder) || void 0 === e2 ? void 0 : e2.getSelectedRange();
      }
    }
    update(t2) {
      if (this.data.update = t2, this.isSignificant()) {
        const t3 = this.selectPlaceholder();
        t3 && (this.forgetPlaceholder(), this.range = t3);
      }
    }
    end(t2) {
      return this.data.end = t2, this.isSignificant() ? (this.forgetPlaceholder(), this.canApplyToDocument() ? (this.setInputSummary({ preferDocument: true, didInput: false }), null === (e2 = this.delegate) || void 0 === e2 || e2.inputControllerWillPerformTyping(), null === (i2 = this.responder) || void 0 === i2 || i2.setSelectedRange(this.range), null === (n2 = this.responder) || void 0 === n2 || n2.insertString(this.data.end), null === (r2 = this.responder) || void 0 === r2 ? void 0 : r2.setSelectedRange(this.range[0] + this.data.end.length)) : null != this.data.start || null != this.data.update ? (this.requestReparse(), this.inputController.reset()) : void 0) : this.inputController.reset();
      var e2, i2, n2, r2;
    }
    getEndData() {
      return this.data.end;
    }
    isEnded() {
      return null != this.getEndData();
    }
    isSignificant() {
      return !$i.composesExistingText || this.inputSummary.didInput;
    }
    canApplyToDocument() {
      var t2, e2;
      return 0 === (null === (t2 = this.data.start) || void 0 === t2 ? void 0 : t2.length) && (null === (e2 = this.data.end) || void 0 === e2 ? void 0 : e2.length) > 0 && this.range;
    }
  };
  rn.proxyMethod("inputController.setInputSummary"), rn.proxyMethod("inputController.requestRender"), rn.proxyMethod("inputController.requestReparse"), rn.proxyMethod("responder?.selectionIsExpanded"), rn.proxyMethod("responder?.insertPlaceholder"), rn.proxyMethod("responder?.selectPlaceholder"), rn.proxyMethod("responder?.forgetPlaceholder");
  var on = class extends Ki {
    constructor() {
      super(...arguments), this.render = this.render.bind(this);
    }
    elementDidMutate() {
      return this.scheduledRender ? this.composing ? null === (t2 = this.delegate) || void 0 === t2 || null === (e2 = t2.inputControllerDidAllowUnhandledInput) || void 0 === e2 ? void 0 : e2.call(t2) : void 0 : this.reparse();
      var t2, e2;
    }
    scheduleRender() {
      return this.scheduledRender ? this.scheduledRender : this.scheduledRender = requestAnimationFrame(this.render);
    }
    render() {
      var t2, e2;
      (cancelAnimationFrame(this.scheduledRender), this.scheduledRender = null, this.composing) || (null === (e2 = this.delegate) || void 0 === e2 || e2.render());
      null === (t2 = this.afterRender) || void 0 === t2 || t2.call(this), this.afterRender = null;
    }
    reparse() {
      var t2;
      return null === (t2 = this.delegate) || void 0 === t2 ? void 0 : t2.reparse();
    }
    insertString() {
      var t2;
      let e2 = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : "", i2 = arguments.length > 1 ? arguments[1] : void 0;
      return null === (t2 = this.delegate) || void 0 === t2 || t2.inputControllerWillPerformTyping(), this.withTargetDOMRange(function() {
        var t3;
        return null === (t3 = this.responder) || void 0 === t3 ? void 0 : t3.insertString(e2, i2);
      });
    }
    toggleAttributeIfSupported(t2) {
      var e2;
      if (dt().includes(t2))
        return null === (e2 = this.delegate) || void 0 === e2 || e2.inputControllerWillPerformFormatting(t2), this.withTargetDOMRange(function() {
          var e3;
          return null === (e3 = this.responder) || void 0 === e3 ? void 0 : e3.toggleCurrentAttribute(t2);
        });
    }
    activateAttributeIfSupported(t2, e2) {
      var i2;
      if (dt().includes(t2))
        return null === (i2 = this.delegate) || void 0 === i2 || i2.inputControllerWillPerformFormatting(t2), this.withTargetDOMRange(function() {
          var i3;
          return null === (i3 = this.responder) || void 0 === i3 ? void 0 : i3.setCurrentAttribute(t2, e2);
        });
    }
    deleteInDirection(t2) {
      let { recordUndoEntry: e2 } = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : { recordUndoEntry: true };
      var i2;
      e2 && (null === (i2 = this.delegate) || void 0 === i2 || i2.inputControllerWillPerformTyping());
      const n2 = () => {
        var e3;
        return null === (e3 = this.responder) || void 0 === e3 ? void 0 : e3.deleteInDirection(t2);
      }, r2 = this.getTargetDOMRange({ minLength: this.composing ? 1 : 2 });
      return r2 ? this.withTargetDOMRange(r2, n2) : n2();
    }
    withTargetDOMRange(t2, e2) {
      var i2;
      return "function" == typeof t2 && (e2 = t2, t2 = this.getTargetDOMRange()), t2 ? null === (i2 = this.responder) || void 0 === i2 ? void 0 : i2.withTargetDOMRange(t2, e2.bind(this)) : (Pt.reset(), e2.call(this));
    }
    getTargetDOMRange() {
      var t2, e2;
      let { minLength: i2 } = arguments.length > 0 && void 0 !== arguments[0] ? arguments[0] : { minLength: 0 };
      const n2 = null === (t2 = (e2 = this.event).getTargetRanges) || void 0 === t2 ? void 0 : t2.call(e2);
      if (n2 && n2.length) {
        const t3 = sn(n2[0]);
        if (0 === i2 || t3.toString().length >= i2)
          return t3;
      }
    }
    withEvent(t2, e2) {
      let i2;
      this.event = t2;
      try {
        i2 = e2.call(this);
      } finally {
        this.event = null;
      }
      return i2;
    }
  };
  Re(on, "events", { keydown(t2) {
    if (kt(t2)) {
      var e2;
      const i2 = hn(t2);
      null !== (e2 = this.delegate) && void 0 !== e2 && e2.inputControllerDidReceiveKeyboardCommand(i2) && t2.preventDefault();
    } else {
      let e3 = t2.key;
      t2.altKey && (e3 += "+Alt"), t2.shiftKey && (e3 += "+Shift");
      const i2 = this.constructor.keys[e3];
      if (i2)
        return this.withEvent(t2, i2);
    }
  }, paste(t2) {
    var e2;
    let i2;
    const n2 = null === (e2 = t2.clipboardData) || void 0 === e2 ? void 0 : e2.getData("URL");
    return cn(t2) ? (t2.preventDefault(), this.attachFiles(t2.clipboardData.files)) : un(t2) ? (t2.preventDefault(), i2 = { type: "text/plain", string: t2.clipboardData.getData("text/plain") }, null === (r2 = this.delegate) || void 0 === r2 || r2.inputControllerWillPaste(i2), null === (o2 = this.responder) || void 0 === o2 || o2.insertString(i2.string), this.render(), null === (s2 = this.delegate) || void 0 === s2 ? void 0 : s2.inputControllerDidPaste(i2)) : n2 ? (t2.preventDefault(), i2 = { type: "text/html", html: this.createLinkHTML(n2) }, null === (a2 = this.delegate) || void 0 === a2 || a2.inputControllerWillPaste(i2), null === (l2 = this.responder) || void 0 === l2 || l2.insertHTML(i2.html), this.render(), null === (c2 = this.delegate) || void 0 === c2 ? void 0 : c2.inputControllerDidPaste(i2)) : void 0;
    var r2, o2, s2, a2, l2, c2;
  }, beforeinput(t2) {
    const e2 = this.constructor.inputTypes[t2.inputType];
    e2 && (this.withEvent(t2, e2), this.scheduleRender());
  }, input(t2) {
    Pt.reset();
  }, dragstart(t2) {
    var e2, i2;
    null !== (e2 = this.responder) && void 0 !== e2 && e2.selectionContainsAttachments() && (t2.dataTransfer.setData("application/x-trix-dragging", true), this.dragging = { range: null === (i2 = this.responder) || void 0 === i2 ? void 0 : i2.getSelectedRange(), point: dn(t2) });
  }, dragenter(t2) {
    an(t2) && t2.preventDefault();
  }, dragover(t2) {
    if (this.dragging) {
      t2.preventDefault();
      const i2 = dn(t2);
      var e2;
      if (!St(i2, this.dragging.point))
        return this.dragging.point = i2, null === (e2 = this.responder) || void 0 === e2 ? void 0 : e2.setLocationRangeFromPointRange(i2);
    } else
      an(t2) && t2.preventDefault();
  }, drop(t2) {
    var e2, i2;
    if (this.dragging)
      return t2.preventDefault(), null === (e2 = this.delegate) || void 0 === e2 || e2.inputControllerWillMoveText(), null === (i2 = this.responder) || void 0 === i2 || i2.moveTextFromRange(this.dragging.range), this.dragging = null, this.scheduleRender();
    if (an(t2)) {
      var n2;
      t2.preventDefault();
      const e3 = dn(t2);
      return null === (n2 = this.responder) || void 0 === n2 || n2.setLocationRangeFromPointRange(e3), this.attachFiles(t2.dataTransfer.files);
    }
  }, dragend() {
    var t2;
    this.dragging && (null === (t2 = this.responder) || void 0 === t2 || t2.setSelectedRange(this.dragging.range), this.dragging = null);
  }, compositionend(t2) {
    this.composing && (this.composing = false, a.recentAndroid || this.scheduleRender());
  } }), Re(on, "keys", { ArrowLeft() {
    var t2, e2;
    if (null !== (t2 = this.responder) && void 0 !== t2 && t2.shouldManageMovingCursorInDirection("backward"))
      return this.event.preventDefault(), null === (e2 = this.responder) || void 0 === e2 ? void 0 : e2.moveCursorInDirection("backward");
  }, ArrowRight() {
    var t2, e2;
    if (null !== (t2 = this.responder) && void 0 !== t2 && t2.shouldManageMovingCursorInDirection("forward"))
      return this.event.preventDefault(), null === (e2 = this.responder) || void 0 === e2 ? void 0 : e2.moveCursorInDirection("forward");
  }, Backspace() {
    var t2, e2, i2;
    if (null !== (t2 = this.responder) && void 0 !== t2 && t2.shouldManageDeletingInDirection("backward"))
      return this.event.preventDefault(), null === (e2 = this.delegate) || void 0 === e2 || e2.inputControllerWillPerformTyping(), null === (i2 = this.responder) || void 0 === i2 || i2.deleteInDirection("backward"), this.render();
  }, Tab() {
    var t2, e2;
    if (null !== (t2 = this.responder) && void 0 !== t2 && t2.canIncreaseNestingLevel())
      return this.event.preventDefault(), null === (e2 = this.responder) || void 0 === e2 || e2.increaseNestingLevel(), this.render();
  }, "Tab+Shift"() {
    var t2, e2;
    if (null !== (t2 = this.responder) && void 0 !== t2 && t2.canDecreaseNestingLevel())
      return this.event.preventDefault(), null === (e2 = this.responder) || void 0 === e2 || e2.decreaseNestingLevel(), this.render();
  } }), Re(on, "inputTypes", { deleteByComposition() {
    return this.deleteInDirection("backward", { recordUndoEntry: false });
  }, deleteByCut() {
    return this.deleteInDirection("backward");
  }, deleteByDrag() {
    return this.event.preventDefault(), this.withTargetDOMRange(function() {
      var t2;
      this.deleteByDragRange = null === (t2 = this.responder) || void 0 === t2 ? void 0 : t2.getSelectedRange();
    });
  }, deleteCompositionText() {
    return this.deleteInDirection("backward", { recordUndoEntry: false });
  }, deleteContent() {
    return this.deleteInDirection("backward");
  }, deleteContentBackward() {
    return this.deleteInDirection("backward");
  }, deleteContentForward() {
    return this.deleteInDirection("forward");
  }, deleteEntireSoftLine() {
    return this.deleteInDirection("forward");
  }, deleteHardLineBackward() {
    return this.deleteInDirection("backward");
  }, deleteHardLineForward() {
    return this.deleteInDirection("forward");
  }, deleteSoftLineBackward() {
    return this.deleteInDirection("backward");
  }, deleteSoftLineForward() {
    return this.deleteInDirection("forward");
  }, deleteWordBackward() {
    return this.deleteInDirection("backward");
  }, deleteWordForward() {
    return this.deleteInDirection("forward");
  }, formatBackColor() {
    return this.activateAttributeIfSupported("backgroundColor", this.event.data);
  }, formatBold() {
    return this.toggleAttributeIfSupported("bold");
  }, formatFontColor() {
    return this.activateAttributeIfSupported("color", this.event.data);
  }, formatFontName() {
    return this.activateAttributeIfSupported("font", this.event.data);
  }, formatIndent() {
    var t2;
    if (null !== (t2 = this.responder) && void 0 !== t2 && t2.canIncreaseNestingLevel())
      return this.withTargetDOMRange(function() {
        var t3;
        return null === (t3 = this.responder) || void 0 === t3 ? void 0 : t3.increaseNestingLevel();
      });
  }, formatItalic() {
    return this.toggleAttributeIfSupported("italic");
  }, formatJustifyCenter() {
    return this.toggleAttributeIfSupported("justifyCenter");
  }, formatJustifyFull() {
    return this.toggleAttributeIfSupported("justifyFull");
  }, formatJustifyLeft() {
    return this.toggleAttributeIfSupported("justifyLeft");
  }, formatJustifyRight() {
    return this.toggleAttributeIfSupported("justifyRight");
  }, formatOutdent() {
    var t2;
    if (null !== (t2 = this.responder) && void 0 !== t2 && t2.canDecreaseNestingLevel())
      return this.withTargetDOMRange(function() {
        var t3;
        return null === (t3 = this.responder) || void 0 === t3 ? void 0 : t3.decreaseNestingLevel();
      });
  }, formatRemove() {
    this.withTargetDOMRange(function() {
      for (const i2 in null === (t2 = this.responder) || void 0 === t2 ? void 0 : t2.getCurrentAttributes()) {
        var t2, e2;
        null === (e2 = this.responder) || void 0 === e2 || e2.removeCurrentAttribute(i2);
      }
    });
  }, formatSetBlockTextDirection() {
    return this.activateAttributeIfSupported("blockDir", this.event.data);
  }, formatSetInlineTextDirection() {
    return this.activateAttributeIfSupported("textDir", this.event.data);
  }, formatStrikeThrough() {
    return this.toggleAttributeIfSupported("strike");
  }, formatSubscript() {
    return this.toggleAttributeIfSupported("sub");
  }, formatSuperscript() {
    return this.toggleAttributeIfSupported("sup");
  }, formatUnderline() {
    return this.toggleAttributeIfSupported("underline");
  }, historyRedo() {
    var t2;
    return null === (t2 = this.delegate) || void 0 === t2 ? void 0 : t2.inputControllerWillPerformRedo();
  }, historyUndo() {
    var t2;
    return null === (t2 = this.delegate) || void 0 === t2 ? void 0 : t2.inputControllerWillPerformUndo();
  }, insertCompositionText() {
    return this.composing = true, this.insertString(this.event.data);
  }, insertFromComposition() {
    return this.composing = false, this.insertString(this.event.data);
  }, insertFromDrop() {
    const t2 = this.deleteByDragRange;
    var e2;
    if (t2)
      return this.deleteByDragRange = null, null === (e2 = this.delegate) || void 0 === e2 || e2.inputControllerWillMoveText(), this.withTargetDOMRange(function() {
        var e3;
        return null === (e3 = this.responder) || void 0 === e3 ? void 0 : e3.moveTextFromRange(t2);
      });
  }, insertFromPaste() {
    const { dataTransfer: t2 } = this.event, e2 = { dataTransfer: t2 }, i2 = t2.getData("URL"), n2 = t2.getData("text/html");
    if (i2) {
      var r2;
      let n3;
      this.event.preventDefault(), e2.type = "text/html";
      const o3 = t2.getData("public.url-name");
      n3 = o3 ? qt(o3).trim() : i2, e2.html = this.createLinkHTML(i2, n3), null === (r2 = this.delegate) || void 0 === r2 || r2.inputControllerWillPaste(e2), this.withTargetDOMRange(function() {
        var t3;
        return null === (t3 = this.responder) || void 0 === t3 ? void 0 : t3.insertHTML(e2.html);
      }), this.afterRender = () => {
        var t3;
        return null === (t3 = this.delegate) || void 0 === t3 ? void 0 : t3.inputControllerDidPaste(e2);
      };
    } else if (Ct(t2)) {
      var o2;
      e2.type = "text/plain", e2.string = t2.getData("text/plain"), null === (o2 = this.delegate) || void 0 === o2 || o2.inputControllerWillPaste(e2), this.withTargetDOMRange(function() {
        var t3;
        return null === (t3 = this.responder) || void 0 === t3 ? void 0 : t3.insertString(e2.string);
      }), this.afterRender = () => {
        var t3;
        return null === (t3 = this.delegate) || void 0 === t3 ? void 0 : t3.inputControllerDidPaste(e2);
      };
    } else if (ln(this.event)) {
      var s2;
      e2.type = "File", e2.file = t2.files[0], null === (s2 = this.delegate) || void 0 === s2 || s2.inputControllerWillPaste(e2), this.withTargetDOMRange(function() {
        var t3;
        return null === (t3 = this.responder) || void 0 === t3 ? void 0 : t3.insertFile(e2.file);
      }), this.afterRender = () => {
        var t3;
        return null === (t3 = this.delegate) || void 0 === t3 ? void 0 : t3.inputControllerDidPaste(e2);
      };
    } else if (n2) {
      var a2;
      this.event.preventDefault(), e2.type = "text/html", e2.html = n2, null === (a2 = this.delegate) || void 0 === a2 || a2.inputControllerWillPaste(e2), this.withTargetDOMRange(function() {
        var t3;
        return null === (t3 = this.responder) || void 0 === t3 ? void 0 : t3.insertHTML(e2.html);
      }), this.afterRender = () => {
        var t3;
        return null === (t3 = this.delegate) || void 0 === t3 ? void 0 : t3.inputControllerDidPaste(e2);
      };
    }
  }, insertFromYank() {
    return this.insertString(this.event.data);
  }, insertLineBreak() {
    return this.insertString("\n");
  }, insertLink() {
    return this.activateAttributeIfSupported("href", this.event.data);
  }, insertOrderedList() {
    return this.toggleAttributeIfSupported("number");
  }, insertParagraph() {
    var t2;
    return null === (t2 = this.delegate) || void 0 === t2 || t2.inputControllerWillPerformTyping(), this.withTargetDOMRange(function() {
      var t3;
      return null === (t3 = this.responder) || void 0 === t3 ? void 0 : t3.insertLineBreak();
    });
  }, insertReplacementText() {
    const t2 = this.event.dataTransfer.getData("text/plain"), e2 = this.event.getTargetRanges()[0];
    this.withTargetDOMRange(e2, () => {
      this.insertString(t2, { updatePosition: false });
    });
  }, insertText() {
    var t2;
    return this.insertString(this.event.data || (null === (t2 = this.event.dataTransfer) || void 0 === t2 ? void 0 : t2.getData("text/plain")));
  }, insertTranspose() {
    return this.insertString(this.event.data);
  }, insertUnorderedList() {
    return this.toggleAttributeIfSupported("bullet");
  } });
  var sn = function(t2) {
    const e2 = document.createRange();
    return e2.setStart(t2.startContainer, t2.startOffset), e2.setEnd(t2.endContainer, t2.endOffset), e2;
  };
  var an = (t2) => {
    var e2;
    return Array.from((null === (e2 = t2.dataTransfer) || void 0 === e2 ? void 0 : e2.types) || []).includes("Files");
  };
  var ln = (t2) => {
    var e2;
    return (null === (e2 = t2.dataTransfer.files) || void 0 === e2 ? void 0 : e2[0]) && !cn(t2) && !((t3) => {
      let { dataTransfer: e3 } = t3;
      return e3.types.includes("Files") && e3.types.includes("text/html") && e3.getData("text/html").includes("urn:schemas-microsoft-com:office:office");
    })(t2);
  };
  var cn = function(t2) {
    const e2 = t2.clipboardData;
    if (e2) {
      return Array.from(e2.types).filter((t3) => t3.match(/file/i)).length === e2.types.length && e2.files.length >= 1;
    }
  };
  var un = function(t2) {
    const e2 = t2.clipboardData;
    if (e2)
      return e2.types.includes("text/plain") && 1 === e2.types.length;
  };
  var hn = function(t2) {
    const e2 = [];
    return t2.altKey && e2.push("alt"), t2.shiftKey && e2.push("shift"), e2.push(t2.key), e2;
  };
  var dn = (t2) => ({ x: t2.clientX, y: t2.clientY });
  var gn = "[data-trix-attribute]";
  var mn = "[data-trix-action]";
  var pn = "".concat(gn, ", ").concat(mn);
  var fn = "[data-trix-dialog]";
  var bn = "".concat(fn, "[data-trix-active]");
  var vn = "".concat(fn, " [data-trix-method]");
  var An = "".concat(fn, " [data-trix-input]");
  var xn = (t2, e2) => (e2 || (e2 = Cn(t2)), t2.querySelector("[data-trix-input][name='".concat(e2, "']")));
  var yn = (t2) => t2.getAttribute("data-trix-action");
  var Cn = (t2) => t2.getAttribute("data-trix-attribute") || t2.getAttribute("data-trix-dialog-attribute");
  var kn = class extends H {
    constructor(t2) {
      super(t2), this.didClickActionButton = this.didClickActionButton.bind(this), this.didClickAttributeButton = this.didClickAttributeButton.bind(this), this.didClickDialogButton = this.didClickDialogButton.bind(this), this.didKeyDownDialogInput = this.didKeyDownDialogInput.bind(this), this.element = t2, this.attributes = {}, this.actions = {}, this.resetDialogInputs(), f("mousedown", { onElement: this.element, matchingSelector: mn, withCallback: this.didClickActionButton }), f("mousedown", { onElement: this.element, matchingSelector: gn, withCallback: this.didClickAttributeButton }), f("click", { onElement: this.element, matchingSelector: pn, preventDefault: true }), f("click", { onElement: this.element, matchingSelector: vn, withCallback: this.didClickDialogButton }), f("keydown", { onElement: this.element, matchingSelector: An, withCallback: this.didKeyDownDialogInput });
    }
    didClickActionButton(t2, e2) {
      var i2;
      null === (i2 = this.delegate) || void 0 === i2 || i2.toolbarDidClickButton(), t2.preventDefault();
      const n2 = yn(e2);
      return this.getDialog(n2) ? this.toggleDialog(n2) : null === (r2 = this.delegate) || void 0 === r2 ? void 0 : r2.toolbarDidInvokeAction(n2, e2);
      var r2;
    }
    didClickAttributeButton(t2, e2) {
      var i2;
      null === (i2 = this.delegate) || void 0 === i2 || i2.toolbarDidClickButton(), t2.preventDefault();
      const n2 = Cn(e2);
      var r2;
      this.getDialog(n2) ? this.toggleDialog(n2) : null === (r2 = this.delegate) || void 0 === r2 || r2.toolbarDidToggleAttribute(n2);
      return this.refreshAttributeButtons();
    }
    didClickDialogButton(t2, e2) {
      const i2 = A(e2, { matchingSelector: fn });
      return this[e2.getAttribute("data-trix-method")].call(this, i2);
    }
    didKeyDownDialogInput(t2, e2) {
      if (13 === t2.keyCode) {
        t2.preventDefault();
        const i2 = e2.getAttribute("name"), n2 = this.getDialog(i2);
        this.setAttribute(n2);
      }
      if (27 === t2.keyCode)
        return t2.preventDefault(), this.hideDialog();
    }
    updateActions(t2) {
      return this.actions = t2, this.refreshActionButtons();
    }
    refreshActionButtons() {
      return this.eachActionButton((t2, e2) => {
        t2.disabled = false === this.actions[e2];
      });
    }
    eachActionButton(t2) {
      return Array.from(this.element.querySelectorAll(mn)).map((e2) => t2(e2, yn(e2)));
    }
    updateAttributes(t2) {
      return this.attributes = t2, this.refreshAttributeButtons();
    }
    refreshAttributeButtons() {
      return this.eachAttributeButton((t2, e2) => (t2.disabled = false === this.attributes[e2], this.attributes[e2] || this.dialogIsVisible(e2) ? (t2.setAttribute("data-trix-active", ""), t2.classList.add("trix-active")) : (t2.removeAttribute("data-trix-active"), t2.classList.remove("trix-active"))));
    }
    eachAttributeButton(t2) {
      return Array.from(this.element.querySelectorAll(gn)).map((e2) => t2(e2, Cn(e2)));
    }
    applyKeyboardCommand(t2) {
      const e2 = JSON.stringify(t2.sort());
      for (const t3 of Array.from(this.element.querySelectorAll("[data-trix-key]"))) {
        const i2 = t3.getAttribute("data-trix-key").split("+");
        if (JSON.stringify(i2.sort()) === e2)
          return b("mousedown", { onElement: t3 }), true;
      }
      return false;
    }
    dialogIsVisible(t2) {
      const e2 = this.getDialog(t2);
      if (e2)
        return e2.hasAttribute("data-trix-active");
    }
    toggleDialog(t2) {
      return this.dialogIsVisible(t2) ? this.hideDialog() : this.showDialog(t2);
    }
    showDialog(t2) {
      var e2, i2;
      this.hideDialog(), null === (e2 = this.delegate) || void 0 === e2 || e2.toolbarWillShowDialog();
      const n2 = this.getDialog(t2);
      n2.setAttribute("data-trix-active", ""), n2.classList.add("trix-active"), Array.from(n2.querySelectorAll("input[disabled]")).forEach((t3) => {
        t3.removeAttribute("disabled");
      });
      const r2 = Cn(n2);
      if (r2) {
        const e3 = xn(n2, t2);
        e3 && (e3.value = this.attributes[r2] || "", e3.select());
      }
      return null === (i2 = this.delegate) || void 0 === i2 ? void 0 : i2.toolbarDidShowDialog(t2);
    }
    setAttribute(t2) {
      const e2 = Cn(t2), i2 = xn(t2, e2);
      return i2.willValidate && !i2.checkValidity() ? (i2.setAttribute("data-trix-validate", ""), i2.classList.add("trix-validate"), i2.focus()) : (null === (n2 = this.delegate) || void 0 === n2 || n2.toolbarDidUpdateAttribute(e2, i2.value), this.hideDialog());
      var n2;
    }
    removeAttribute(t2) {
      var e2;
      const i2 = Cn(t2);
      return null === (e2 = this.delegate) || void 0 === e2 || e2.toolbarDidRemoveAttribute(i2), this.hideDialog();
    }
    hideDialog() {
      const t2 = this.element.querySelector(bn);
      var e2;
      if (t2)
        return t2.removeAttribute("data-trix-active"), t2.classList.remove("trix-active"), this.resetDialogInputs(), null === (e2 = this.delegate) || void 0 === e2 ? void 0 : e2.toolbarDidHideDialog(((t3) => t3.getAttribute("data-trix-dialog"))(t2));
    }
    resetDialogInputs() {
      Array.from(this.element.querySelectorAll(An)).forEach((t2) => {
        t2.setAttribute("disabled", "disabled"), t2.removeAttribute("data-trix-validate"), t2.classList.remove("trix-validate");
      });
    }
    getDialog(t2) {
      return this.element.querySelector("[data-trix-dialog=".concat(t2, "]"));
    }
  };
  var Rn = class extends Oi {
    constructor(t2) {
      let { editorElement: e2, document: i2, html: n2 } = t2;
      super(...arguments), this.editorElement = e2, this.selectionManager = new Li(this.editorElement), this.selectionManager.delegate = this, this.composition = new gi(), this.composition.delegate = this, this.attachmentManager = new hi(this.composition.getAttachments()), this.attachmentManager.delegate = this, this.inputController = 2 === M.getLevel() ? new on(this.editorElement) : new Qi(this.editorElement), this.inputController.delegate = this, this.inputController.responder = this.composition, this.compositionController = new Ni(this.editorElement, this.composition), this.compositionController.delegate = this, this.toolbarController = new kn(this.editorElement.toolbarElement), this.toolbarController.delegate = this, this.editor = new xi(this.composition, this.selectionManager, this.editorElement), i2 ? this.editor.loadDocument(i2) : this.editor.loadHTML(n2);
    }
    registerSelectionManager() {
      return Pt.registerSelectionManager(this.selectionManager);
    }
    unregisterSelectionManager() {
      return Pt.unregisterSelectionManager(this.selectionManager);
    }
    render() {
      return this.compositionController.render();
    }
    reparse() {
      return this.composition.replaceHTML(this.editorElement.innerHTML);
    }
    compositionDidChangeDocument(t2) {
      if (this.notifyEditorElement("document-change"), !this.handlingInput)
        return this.render();
    }
    compositionDidChangeCurrentAttributes(t2) {
      return this.currentAttributes = t2, this.toolbarController.updateAttributes(this.currentAttributes), this.updateCurrentActions(), this.notifyEditorElement("attributes-change", { attributes: this.currentAttributes });
    }
    compositionDidPerformInsertionAtRange(t2) {
      this.pasting && (this.pastedRange = t2);
    }
    compositionShouldAcceptFile(t2) {
      return this.notifyEditorElement("file-accept", { file: t2 });
    }
    compositionDidAddAttachment(t2) {
      const e2 = this.attachmentManager.manageAttachment(t2);
      return this.notifyEditorElement("attachment-add", { attachment: e2 });
    }
    compositionDidEditAttachment(t2) {
      this.compositionController.rerenderViewForObject(t2);
      const e2 = this.attachmentManager.manageAttachment(t2);
      return this.notifyEditorElement("attachment-edit", { attachment: e2 }), this.notifyEditorElement("change");
    }
    compositionDidChangeAttachmentPreviewURL(t2) {
      return this.compositionController.invalidateViewForObject(t2), this.notifyEditorElement("change");
    }
    compositionDidRemoveAttachment(t2) {
      const e2 = this.attachmentManager.unmanageAttachment(t2);
      return this.notifyEditorElement("attachment-remove", { attachment: e2 });
    }
    compositionDidStartEditingAttachment(t2, e2) {
      return this.attachmentLocationRange = this.composition.document.getLocationRangeOfAttachment(t2), this.compositionController.installAttachmentEditorForAttachment(t2, e2), this.selectionManager.setLocationRange(this.attachmentLocationRange);
    }
    compositionDidStopEditingAttachment(t2) {
      this.compositionController.uninstallAttachmentEditor(), this.attachmentLocationRange = null;
    }
    compositionDidRequestChangingSelectionToLocationRange(t2) {
      if (!this.loadingSnapshot || this.isFocused())
        return this.requestedLocationRange = t2, this.compositionRevisionWhenLocationRangeRequested = this.composition.revision, this.handlingInput ? void 0 : this.render();
    }
    compositionWillLoadSnapshot() {
      this.loadingSnapshot = true;
    }
    compositionDidLoadSnapshot() {
      this.compositionController.refreshViewCache(), this.render(), this.loadingSnapshot = false;
    }
    getSelectionManager() {
      return this.selectionManager;
    }
    attachmentManagerDidRequestRemovalOfAttachment(t2) {
      return this.removeAttachment(t2);
    }
    compositionControllerWillSyncDocumentView() {
      return this.inputController.editorWillSyncDocumentView(), this.selectionManager.lock(), this.selectionManager.clearSelection();
    }
    compositionControllerDidSyncDocumentView() {
      return this.inputController.editorDidSyncDocumentView(), this.selectionManager.unlock(), this.updateCurrentActions(), this.notifyEditorElement("sync");
    }
    compositionControllerDidRender() {
      this.requestedLocationRange && (this.compositionRevisionWhenLocationRangeRequested === this.composition.revision && this.selectionManager.setLocationRange(this.requestedLocationRange), this.requestedLocationRange = null, this.compositionRevisionWhenLocationRangeRequested = null), this.renderedCompositionRevision !== this.composition.revision && (this.runEditorFilters(), this.composition.updateCurrentAttributes(), this.notifyEditorElement("render")), this.renderedCompositionRevision = this.composition.revision;
    }
    compositionControllerDidFocus() {
      return this.isFocusedInvisibly() && this.setLocationRange({ index: 0, offset: 0 }), this.toolbarController.hideDialog(), this.notifyEditorElement("focus");
    }
    compositionControllerDidBlur() {
      return this.notifyEditorElement("blur");
    }
    compositionControllerDidSelectAttachment(t2, e2) {
      return this.toolbarController.hideDialog(), this.composition.editAttachment(t2, e2);
    }
    compositionControllerDidRequestDeselectingAttachment(t2) {
      const e2 = this.attachmentLocationRange || this.composition.document.getLocationRangeOfAttachment(t2);
      return this.selectionManager.setLocationRange(e2[1]);
    }
    compositionControllerWillUpdateAttachment(t2) {
      return this.editor.recordUndoEntry("Edit Attachment", { context: t2.id, consolidatable: true });
    }
    compositionControllerDidRequestRemovalOfAttachment(t2) {
      return this.removeAttachment(t2);
    }
    inputControllerWillHandleInput() {
      this.handlingInput = true, this.requestedRender = false;
    }
    inputControllerDidRequestRender() {
      this.requestedRender = true;
    }
    inputControllerDidHandleInput() {
      if (this.handlingInput = false, this.requestedRender)
        return this.requestedRender = false, this.render();
    }
    inputControllerDidAllowUnhandledInput() {
      return this.notifyEditorElement("change");
    }
    inputControllerDidRequestReparse() {
      return this.reparse();
    }
    inputControllerWillPerformTyping() {
      return this.recordTypingUndoEntry();
    }
    inputControllerWillPerformFormatting(t2) {
      return this.recordFormattingUndoEntry(t2);
    }
    inputControllerWillCutText() {
      return this.editor.recordUndoEntry("Cut");
    }
    inputControllerWillPaste(t2) {
      return this.editor.recordUndoEntry("Paste"), this.pasting = true, this.notifyEditorElement("before-paste", { paste: t2 });
    }
    inputControllerDidPaste(t2) {
      return t2.range = this.pastedRange, this.pastedRange = null, this.pasting = null, this.notifyEditorElement("paste", { paste: t2 });
    }
    inputControllerWillMoveText() {
      return this.editor.recordUndoEntry("Move");
    }
    inputControllerWillAttachFiles() {
      return this.editor.recordUndoEntry("Drop Files");
    }
    inputControllerWillPerformUndo() {
      return this.editor.undo();
    }
    inputControllerWillPerformRedo() {
      return this.editor.redo();
    }
    inputControllerDidReceiveKeyboardCommand(t2) {
      return this.toolbarController.applyKeyboardCommand(t2);
    }
    inputControllerDidStartDrag() {
      this.locationRangeBeforeDrag = this.selectionManager.getLocationRange();
    }
    inputControllerDidReceiveDragOverPoint(t2) {
      return this.selectionManager.setLocationRangeFromPointRange(t2);
    }
    inputControllerDidCancelDrag() {
      this.selectionManager.setLocationRange(this.locationRangeBeforeDrag), this.locationRangeBeforeDrag = null;
    }
    locationRangeDidChange(t2) {
      return this.composition.updateCurrentAttributes(), this.updateCurrentActions(), this.attachmentLocationRange && !wt(this.attachmentLocationRange, t2) && this.composition.stopEditingAttachment(), this.notifyEditorElement("selection-change");
    }
    toolbarDidClickButton() {
      if (!this.getLocationRange())
        return this.setLocationRange({ index: 0, offset: 0 });
    }
    toolbarDidInvokeAction(t2, e2) {
      return this.invokeAction(t2, e2);
    }
    toolbarDidToggleAttribute(t2) {
      if (this.recordFormattingUndoEntry(t2), this.composition.toggleCurrentAttribute(t2), this.render(), !this.selectionFrozen)
        return this.editorElement.focus();
    }
    toolbarDidUpdateAttribute(t2, e2) {
      if (this.recordFormattingUndoEntry(t2), this.composition.setCurrentAttribute(t2, e2), this.render(), !this.selectionFrozen)
        return this.editorElement.focus();
    }
    toolbarDidRemoveAttribute(t2) {
      if (this.recordFormattingUndoEntry(t2), this.composition.removeCurrentAttribute(t2), this.render(), !this.selectionFrozen)
        return this.editorElement.focus();
    }
    toolbarWillShowDialog(t2) {
      return this.composition.expandSelectionForEditing(), this.freezeSelection();
    }
    toolbarDidShowDialog(t2) {
      return this.notifyEditorElement("toolbar-dialog-show", { dialogName: t2 });
    }
    toolbarDidHideDialog(t2) {
      return this.thawSelection(), this.editorElement.focus(), this.notifyEditorElement("toolbar-dialog-hide", { dialogName: t2 });
    }
    freezeSelection() {
      if (!this.selectionFrozen)
        return this.selectionManager.lock(), this.composition.freezeSelection(), this.selectionFrozen = true, this.render();
    }
    thawSelection() {
      if (this.selectionFrozen)
        return this.composition.thawSelection(), this.selectionManager.unlock(), this.selectionFrozen = false, this.render();
    }
    canInvokeAction(t2) {
      return !!this.actionIsExternal(t2) || !(null === (e2 = this.actions[t2]) || void 0 === e2 || null === (e2 = e2.test) || void 0 === e2 || !e2.call(this));
      var e2;
    }
    invokeAction(t2, e2) {
      return this.actionIsExternal(t2) ? this.notifyEditorElement("action-invoke", { actionName: t2, invokingElement: e2 }) : null === (i2 = this.actions[t2]) || void 0 === i2 || null === (i2 = i2.perform) || void 0 === i2 ? void 0 : i2.call(this);
      var i2;
    }
    actionIsExternal(t2) {
      return /^x-./.test(t2);
    }
    getCurrentActions() {
      const t2 = {};
      for (const e2 in this.actions)
        t2[e2] = this.canInvokeAction(e2);
      return t2;
    }
    updateCurrentActions() {
      const t2 = this.getCurrentActions();
      if (!St(t2, this.currentActions))
        return this.currentActions = t2, this.toolbarController.updateActions(this.currentActions), this.notifyEditorElement("actions-change", { actions: this.currentActions });
    }
    runEditorFilters() {
      let t2 = this.composition.getSnapshot();
      if (Array.from(this.editor.filters).forEach((e3) => {
        const { document: i3, selectedRange: n2 } = t2;
        t2 = e3.call(this.editor, t2) || {}, t2.document || (t2.document = i3), t2.selectedRange || (t2.selectedRange = n2);
      }), e2 = t2, i2 = this.composition.getSnapshot(), !wt(e2.selectedRange, i2.selectedRange) || !e2.document.isEqualTo(i2.document))
        return this.composition.loadSnapshot(t2);
      var e2, i2;
    }
    updateInputElement() {
      const t2 = function(t3, e2) {
        const i2 = li[e2];
        if (i2)
          return i2(t3);
        throw new Error("unknown content type: ".concat(e2));
      }(this.compositionController.getSerializableElement(), "text/html");
      return this.editorElement.setInputElementValue(t2);
    }
    notifyEditorElement(t2, e2) {
      switch (t2) {
        case "document-change":
          this.documentChangedSinceLastRender = true;
          break;
        case "render":
          this.documentChangedSinceLastRender && (this.documentChangedSinceLastRender = false, this.notifyEditorElement("change"));
          break;
        case "change":
        case "attachment-add":
        case "attachment-edit":
        case "attachment-remove":
          this.updateInputElement();
      }
      return this.editorElement.notify(t2, e2);
    }
    removeAttachment(t2) {
      return this.editor.recordUndoEntry("Delete Attachment"), this.composition.removeAttachment(t2), this.render();
    }
    recordFormattingUndoEntry(t2) {
      const e2 = gt(t2), i2 = this.selectionManager.getLocationRange();
      if (e2 || !Dt(i2))
        return this.editor.recordUndoEntry("Formatting", { context: this.getUndoContext(), consolidatable: true });
    }
    recordTypingUndoEntry() {
      return this.editor.recordUndoEntry("Typing", { context: this.getUndoContext(this.currentAttributes), consolidatable: true });
    }
    getUndoContext() {
      for (var t2 = arguments.length, e2 = new Array(t2), i2 = 0; i2 < t2; i2++)
        e2[i2] = arguments[i2];
      return [this.getLocationContext(), this.getTimeContext(), ...Array.from(e2)];
    }
    getLocationContext() {
      const t2 = this.selectionManager.getLocationRange();
      return Dt(t2) ? t2[0].index : t2;
    }
    getTimeContext() {
      return q.interval > 0 ? Math.floor(new Date().getTime() / q.interval) : 0;
    }
    isFocused() {
      var t2;
      return this.editorElement === (null === (t2 = this.editorElement.ownerDocument) || void 0 === t2 ? void 0 : t2.activeElement);
    }
    isFocusedInvisibly() {
      return this.isFocused() && !this.getLocationRange();
    }
    get actions() {
      return this.constructor.actions;
    }
  };
  Re(Rn, "actions", { undo: { test() {
    return this.editor.canUndo();
  }, perform() {
    return this.editor.undo();
  } }, redo: { test() {
    return this.editor.canRedo();
  }, perform() {
    return this.editor.redo();
  } }, link: { test() {
    return this.editor.canActivateAttribute("href");
  } }, increaseNestingLevel: { test() {
    return this.editor.canIncreaseNestingLevel();
  }, perform() {
    return this.editor.increaseNestingLevel() && this.render();
  } }, decreaseNestingLevel: { test() {
    return this.editor.canDecreaseNestingLevel();
  }, perform() {
    return this.editor.decreaseNestingLevel() && this.render();
  } }, attachFiles: { test: () => true, perform() {
    return M.pickFiles(this.editor.insertFiles);
  } } }), Rn.proxyMethod("getSelectionManager().setLocationRange"), Rn.proxyMethod("getSelectionManager().getLocationRange");
  var En = Object.freeze({ __proto__: null, AttachmentEditorController: Ii, CompositionController: Ni, Controller: Oi, EditorController: Rn, InputController: Ki, Level0InputController: Qi, Level2InputController: on, ToolbarController: kn });
  var Sn = Object.freeze({ __proto__: null, MutationObserver: Ui, SelectionChangeObserver: Ft });
  var Ln = Object.freeze({ __proto__: null, FileVerificationOperation: Vi, ImagePreloadOperation: Le });
  bt("trix-toolbar", "%t {\n  display: block;\n}\n\n%t {\n  white-space: nowrap;\n}\n\n%t [data-trix-dialog] {\n  display: none;\n}\n\n%t [data-trix-dialog][data-trix-active] {\n  display: block;\n}\n\n%t [data-trix-dialog] [data-trix-validate]:invalid {\n  background-color: #ffdddd;\n}");
  var Dn = class extends HTMLElement {
    connectedCallback() {
      "" === this.innerHTML && (this.innerHTML = U.getDefaultHTML());
    }
  };
  var wn = 0;
  var Tn = function(t2) {
    if (!t2.hasAttribute("contenteditable"))
      return t2.setAttribute("contenteditable", ""), function(t3) {
        let e2 = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
        return e2.times = 1, f(t3, e2);
      }("focus", { onElement: t2, withCallback: () => Bn(t2) });
  };
  var Bn = function(t2) {
    return Fn(t2), Pn(t2);
  };
  var Fn = function(t2) {
    var e2, i2;
    if (null !== (e2 = (i2 = document).queryCommandSupported) && void 0 !== e2 && e2.call(i2, "enableObjectResizing"))
      return document.execCommand("enableObjectResizing", false, false), f("mscontrolselect", { onElement: t2, preventDefault: true });
  };
  var Pn = function(t2) {
    var e2, i2;
    if (null !== (e2 = (i2 = document).queryCommandSupported) && void 0 !== e2 && e2.call(i2, "DefaultParagraphSeparator")) {
      const { tagName: t3 } = n.default;
      if (["div", "p"].includes(t3))
        return document.execCommand("DefaultParagraphSeparator", false, t3);
    }
  };
  var In = a.forcesObjectResizing ? { display: "inline", width: "auto" } : { display: "inline-block", width: "1px" };
  bt("trix-editor", "%t {\n    display: block;\n}\n\n%t:empty:not(:focus)::before {\n    content: attr(placeholder);\n    color: graytext;\n    cursor: text;\n    pointer-events: none;\n    white-space: pre-line;\n}\n\n%t a[contenteditable=false] {\n    cursor: text;\n}\n\n%t img {\n    max-width: 100%;\n    height: auto;\n}\n\n%t ".concat(e, " figcaption textarea {\n    resize: none;\n}\n\n%t ").concat(e, " figcaption textarea.trix-autoresize-clone {\n    position: absolute;\n    left: -9999px;\n    max-height: 0px;\n}\n\n%t ").concat(e, " figcaption[data-trix-placeholder]:empty::before {\n    content: attr(data-trix-placeholder);\n    color: graytext;\n}\n\n%t [data-trix-cursor-target] {\n    display: ").concat(In.display, " !important;\n    width: ").concat(In.width, " !important;\n    padding: 0 !important;\n    margin: 0 !important;\n    border: none !important;\n}\n\n%t [data-trix-cursor-target=left] {\n    vertical-align: top !important;\n    margin-left: -1px !important;\n}\n\n%t [data-trix-cursor-target=right] {\n    vertical-align: bottom !important;\n    margin-right: -1px !important;\n}"));
  var Nn = class extends HTMLElement {
    get trixId() {
      return this.hasAttribute("trix-id") ? this.getAttribute("trix-id") : (this.setAttribute("trix-id", ++wn), this.trixId);
    }
    get labels() {
      const t2 = [];
      this.id && this.ownerDocument && t2.push(...Array.from(this.ownerDocument.querySelectorAll("label[for='".concat(this.id, "']")) || []));
      const e2 = A(this, { matchingSelector: "label" });
      return e2 && [this, null].includes(e2.control) && t2.push(e2), t2;
    }
    get toolbarElement() {
      var t2;
      if (this.hasAttribute("toolbar"))
        return null === (t2 = this.ownerDocument) || void 0 === t2 ? void 0 : t2.getElementById(this.getAttribute("toolbar"));
      if (this.parentNode) {
        const t3 = "trix-toolbar-".concat(this.trixId);
        this.setAttribute("toolbar", t3);
        const e2 = S("trix-toolbar", { id: t3 });
        return this.parentNode.insertBefore(e2, this), e2;
      }
    }
    get form() {
      var t2;
      return null === (t2 = this.inputElement) || void 0 === t2 ? void 0 : t2.form;
    }
    get inputElement() {
      var t2;
      if (this.hasAttribute("input"))
        return null === (t2 = this.ownerDocument) || void 0 === t2 ? void 0 : t2.getElementById(this.getAttribute("input"));
      if (this.parentNode) {
        const t3 = "trix-input-".concat(this.trixId);
        this.setAttribute("input", t3);
        const e2 = S("input", { type: "hidden", id: t3 });
        return this.parentNode.insertBefore(e2, this.nextElementSibling), e2;
      }
    }
    get editor() {
      var t2;
      return null === (t2 = this.editorController) || void 0 === t2 ? void 0 : t2.editor;
    }
    get name() {
      var t2;
      return null === (t2 = this.inputElement) || void 0 === t2 ? void 0 : t2.name;
    }
    get value() {
      var t2;
      return null === (t2 = this.inputElement) || void 0 === t2 ? void 0 : t2.value;
    }
    set value(t2) {
      var e2;
      this.defaultValue = t2, null === (e2 = this.editor) || void 0 === e2 || e2.loadHTML(this.defaultValue);
    }
    notify(t2, e2) {
      if (this.editorController)
        return b("trix-".concat(t2), { onElement: this, attributes: e2 });
    }
    setInputElementValue(t2) {
      this.inputElement && (this.inputElement.value = t2);
    }
    connectedCallback() {
      this.hasAttribute("data-trix-internal") || (Tn(this), function(t2) {
        if (!t2.hasAttribute("role"))
          t2.setAttribute("role", "textbox");
      }(this), function(t2) {
        if (t2.hasAttribute("aria-label") || t2.hasAttribute("aria-labelledby"))
          return;
        const e2 = function() {
          const e3 = Array.from(t2.labels).map((e4) => {
            if (!e4.contains(t2))
              return e4.textContent;
          }).filter((t3) => t3), i2 = e3.join(" ");
          return i2 ? t2.setAttribute("aria-label", i2) : t2.removeAttribute("aria-label");
        };
        e2(), f("focus", { onElement: t2, withCallback: e2 });
      }(this), this.editorController || (b("trix-before-initialize", { onElement: this }), this.editorController = new Rn({ editorElement: this, html: this.defaultValue = this.value }), requestAnimationFrame(() => b("trix-initialize", { onElement: this }))), this.editorController.registerSelectionManager(), this.registerResetListener(), this.registerClickListener(), function(t2) {
        if (!document.querySelector(":focus") && t2.hasAttribute("autofocus") && document.querySelector("[autofocus]") === t2)
          t2.focus();
      }(this));
    }
    disconnectedCallback() {
      var t2;
      return null === (t2 = this.editorController) || void 0 === t2 || t2.unregisterSelectionManager(), this.unregisterResetListener(), this.unregisterClickListener();
    }
    registerResetListener() {
      return this.resetListener = this.resetBubbled.bind(this), window.addEventListener("reset", this.resetListener, false);
    }
    unregisterResetListener() {
      return window.removeEventListener("reset", this.resetListener, false);
    }
    registerClickListener() {
      return this.clickListener = this.clickBubbled.bind(this), window.addEventListener("click", this.clickListener, false);
    }
    unregisterClickListener() {
      return window.removeEventListener("click", this.clickListener, false);
    }
    resetBubbled(t2) {
      if (!t2.defaultPrevented && t2.target === this.form)
        return this.reset();
    }
    clickBubbled(t2) {
      if (t2.defaultPrevented)
        return;
      if (this.contains(t2.target))
        return;
      const e2 = A(t2.target, { matchingSelector: "label" });
      return e2 && Array.from(this.labels).includes(e2) ? this.focus() : void 0;
    }
    reset() {
      this.value = this.defaultValue;
    }
  };
  var On = { VERSION: t, config: V, core: ci, models: Di, views: wi, controllers: En, observers: Sn, operations: Ln, elements: Object.freeze({ __proto__: null, TrixEditorElement: Nn, TrixToolbarElement: Dn }), filters: Object.freeze({ __proto__: null, Filter: bi, attachmentGalleryFilter: vi }) };
  Object.assign(On, Di), window.Trix = On, setTimeout(function() {
    customElements.get("trix-toolbar") || customElements.define("trix-toolbar", Dn), customElements.get("trix-editor") || customElements.define("trix-editor", Nn);
  }, 0);

  // app/javascript/trix_extension.js
  window.Trix = On;
  On.config.toolbar.getDefaultHTML = toolbarDefaultHTML;
  function toolbarDefaultHTML() {
    const { lang } = On.config;
    return `<div class="trix-button-row">
      <span class="trix-button-group trix-button-group--text-tools" data-trix-button-group="text-tools">
        <button type="button" class="trix-button trix-button--icon trix-button--icon-bold" data-trix-attribute="bold" data-trix-key="b" title="${lang.bold}" tabindex="-1">${lang.bold}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-italic" data-trix-attribute="italic" data-trix-key="i" title="${lang.italic}" tabindex="-1">${lang.italic}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-strike" data-trix-attribute="strike" title="${lang.strike}" tabindex="-1">${lang.strike}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-link" data-trix-attribute="href" data-trix-action="link" data-trix-key="k" title="${lang.link}" tabindex="-1">${lang.link}</button>
      </span>

      <span class="trix-button-group trix-button-group--block-tools" data-trix-button-group="block-tools">
        <button type="button" class="trix-button trix-button--icon trix-button--icon-heading-1" data-trix-attribute="heading1" title="${lang.heading1}" tabindex="-1">${lang.heading1}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-quote" data-trix-attribute="quote" title="${lang.quote}" tabindex="-1">${lang.quote}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-code" data-trix-attribute="code" title="${lang.code}" tabindex="-1">${lang.code}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-bullet-list" data-trix-attribute="bullet" title="${lang.bullets}" tabindex="-1">${lang.bullets}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-number-list" data-trix-attribute="number" title="${lang.numbers}" tabindex="-1">${lang.numbers}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-decrease-nesting-level" data-trix-action="decreaseNestingLevel" title="${lang.outdent}" tabindex="-1">${lang.outdent}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-increase-nesting-level" data-trix-action="increaseNestingLevel" title="${lang.indent}" tabindex="-1">${lang.indent}</button>
      </span>

      <span class="trix-button-group trix-button-group--file-tools" data-trix-button-group="file-tools">
        <button type="button" class="trix-button trix-button--icon trix-button--icon-attach" data-trix-action="attachFiles" title="${lang.attachFiles}" tabindex="-1">${lang.attachFiles}</button>
      </span>

      <span class="trix-button-group-spacer"></span>

      <span class="trix-button-group trix-button-group--history-tools" data-trix-button-group="history-tools">
        <button type="button" class="trix-button trix-button--icon trix-button--icon-undo" data-trix-action="undo" data-trix-key="z" title="${lang.undo}" tabindex="-1">${lang.undo}</button>
        <button type="button" class="trix-button trix-button--icon trix-button--icon-redo" data-trix-action="redo" data-trix-key="shift+z" title="${lang.redo}" tabindex="-1">${lang.redo}</button>
      </span>
    </div>

    <div class="trix-dialogs" data-trix-dialogs>
      <div class="trix-dialog trix-dialog--link" data-trix-dialog="href" data-trix-dialog-attribute="href">
        <div class="trix-dialog__link-fields">
          <input type="url" name="href" class="trix-input trix-input--dialog" placeholder="${lang.urlPlaceholder}" aria-label="${lang.url}" required data-trix-input>
          <div class="trix-button-group">
            <input type="button" class="trix-button trix-button--dialog" value="${lang.link}" data-trix-method="setAttribute">
            <input type="button" class="trix-button trix-button--dialog" value="${lang.unlink}" data-trix-method="removeAttribute">
          </div>
        </div>
      </div>
    </div>`;
  }
})();
//# sourceMappingURL=trix_extension.js.map
