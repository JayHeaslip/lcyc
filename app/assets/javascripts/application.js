// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require popper
//= require bootstrap
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load', function() {

    $('form').on('click', '.remove_record', function(e) {
	$(this).prev('input[type=hidden]').val('1');
	$(this).closest('div.person').hide();
	return e.preventDefault();
    });

    $('form').on('click', '.add_person', function(e) {
	var regexp, time;
	time = new Date().getTime();
	regexp = new RegExp($(this).data('id'), 'g');
	$('.person_fields').append($(this).data('personFields').replace(regexp, time));
	return e.preventDefault();
    });

    $("form").on('change', 'div#type_select select', function() {
	var type = this.value;
	alert(type);
    });

});
