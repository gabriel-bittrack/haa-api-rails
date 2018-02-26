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
//= require ./libs/chosen.jquery.min
//= require rails-ujs
//= require turbolinks
//= require_tree .

jQuery(document).on('turbolinks:load',function(){

  var modal_options = {duration: 100, overlay: {fillColor: '#000', opacity: 0.68}};
  $('.modal').plainModal(modal_options);
  $(".au_link").click(function(e) {
    $('#aboutus_modal').plainModal('open');
  });

  $(".sponsor_link").click(function(e) {
    $('#sponsor_modal').plainModal('open');
  });

  $(".member_name").click(function(e) {
    var id = $(this).attr("data-id");
    $('#bio_modal_' + id).plainModal('open');
    e.preventDefault();
  });

  $(".modal .close").click(function(e) {
    $(this).parents('.modal').plainModal('close');
  });

  $(".goback").click(function(e) {
    window.history.back();
    return false;
  });

  $("#states_dropdown").change(function(e) {
    data = {state: $("#states_dropdown").val(), country: $("#countries_dropdown option:selected").attr("country")};

    $.get("/get_cities", data, function(response) {
      $('#cities_dropdown').empty();
      $('#cities_dropdown').append('<option value="" selected="selected" disabled>SELECT A CITY</option>');
      $.each(response, function(key, value) {
        $('#cities_dropdown')
          .append($("<option></option>")
            .attr("value", value["name"])
            .text(value["name"]));
      });
      $('#cities_dropdown').trigger("chosen:updated");

      $(".breadcrumb.state").removeClass("last");
      $(".breadcrumb").removeClass("active");
      $(".breadcrumb.state").addClass("active");
      $(".breadcrumb.city").addClass("last");
      $(".breadcrumb.city").fadeIn();
    })
  });

  $("#cities_dropdown").change(function(e) {
    $(".breadcrumb").removeClass("active");
    $(".breadcrumb.city").removeClass("last");
    $(".breadcrumb.city").addClass("active");
  });

  $('.scrollbar-outer').scrollbar();
  $(".dd_style3 .chosen-select").on("chosen:ready", function(evt, params) {
    $(".dd_style3 .chosen-results").scrollbar();
  });

  $(".chosen-select").chosen({disable_search_threshold: 10});
  $(".breadcrumb.city").hide();

  $('.sliders').slick({
    dots: true,
    centerMode: true,
    centerPadding: '146px',
    slidesToShow: 1,
  });

});
