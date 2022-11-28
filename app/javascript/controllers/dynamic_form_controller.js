import { Controller } from "@hotwired/stimulus";

export default class DynamicFormController extends
Controller {

    static targets = ['personTemplate', 'person', 'boatTemplate', 'boat', 'installmentTemplate', 'installment']
    static values = {
	personWrapperSelector: {
	    type: String,
	    default: '.dynamic-form-person'
	},
	
	boatWrapperSelector: {
	    type: String,
	    default: '.dynamic-form-boat'
	},
	
	installmentWrapperSelector: {
	    type: String,
	    default: '.dynamic-form-installment'
	}
    }
    
    add_person (e) {
	e.preventDefault()
	console.log("calling add person");
	var adding_child = false;
	
	var content = this.personTemplateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime().toString()).replace(/<option value="Partner">/,"<option value=\"Partner\" selected=\"selected\">");

	if (this.element.getElementsByClassName("dynamic-form-person").length > 1) {
	    console.log("adding child");
	    adding_child = true;
	    content = this.personTemplateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime().toString()).replace(/<option value="Child">/,"<option value=\"Child\" selected=\"selected\">")
	    //for (const elem of this.element.getElementsByClassName('child-hide')) {
	    //	elem.hidden = true;
	    //}
	}
	
	this.personTarget.insertAdjacentHTML('beforebegin', content)
	console.log(this.personTarget);

	if (adding_child) {
	    var element = this.personTarget.previousElementSibling;
	    for (const elem of this.element.getElementsByClassName('child-hide')) {
		elem.hidden = true;
	    }
	}
    }
    
    remove_person (e) {
	e.preventDefault()

	// can't delete the last one
	if (this.element.getElementsByClassName("dynamic-form-person").length > 1) {
	    const wrapper = e.currentTarget.closest(this.personWrapperSelectorValue)
	    if (wrapper.dataset.newRecord === 'true') {
		wrapper.remove()
	    } else {
		wrapper.style.display = 'none'
		
		const input = wrapper.querySelector("input[name*='_destroy']")
		input.value = '1'
	    }
	}
    }

    add_boat (e) {
	e.preventDefault()
	var content = this.boatTemplateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime().toString());
	this.boatTarget.insertAdjacentHTML('beforebegin', content)
    }
    
    remove_boat (e) {
	e.preventDefault()
	const wrapper = e.currentTarget.closest(this.boatWrapperSelectorValue)
	if (wrapper.dataset.newRecord === 'true') {
	    wrapper.remove()
	} else {
	    wrapper.style.display = 'none'
	    
	    const input = wrapper.querySelector("input[name*='_destroy']")
	    input.value = '1'
	}
    }

    add_installment (e) {
	e.preventDefault()
	var content = this.installmentTemplateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime().toString());
	this.installmentTarget.insertAdjacentHTML('beforebegin', content)
    }
    
    remove_installment (e) {
	e.preventDefault()
	const wrapper = e.currentTarget.closest(this.installmentWrapperSelectorValue)
	if (wrapper.dataset.newRecord === 'true') {
	    wrapper.remove()
	} else {
	    wrapper.style.display = 'none'
	    
	    const input = wrapper.querySelector("input[name*='_destroy']")
	    input.value = '1'
	}
    }
}
