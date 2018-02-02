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
//= require ./libs/jquery-3.3.1.min
//= require ./libs/jquery.plainmodal.min
//= require ./libs/jquery.scrollbar
//= require rails-ujs
//= require turbolinks
//= require_tree .

jQuery(document).ready(function($) {

  $('.modal').plainModal({overlay: {fillColor: '#000', opacity: 0.68}});
  $(".au_link").click(function(e) {
    $('#aboutus_modal').plainModal('open');
  });

  $(".modal .close").click(function(e) {
    $(this).parents('.modal').plainModal('close');
  });

  //$('.scrollbar-inner').scrollbar();

});
