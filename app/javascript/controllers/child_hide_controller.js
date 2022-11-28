import { Controller } from "@hotwired/stimulus";

export default class ChildHideController extends
Controller {

    static targets = ['hide_added']

    hide (e) {
	e.preventDefault();
	console.log(e.currentTarget.value);
	console.log(e.currentTarget.closest('.person'));
	var elements = e.currentTarget.closest('.person').getElementsByClassName('child-hide');
	console.log(elements);
	if (e.currentTarget.value === "Child") {
	    for (const elem of elements) {
		elem.hidden = true;
	    }
	} else {
	    for (const elem of elements) {
		elem.hidden = false;
	    }
	}
    }
    
}
