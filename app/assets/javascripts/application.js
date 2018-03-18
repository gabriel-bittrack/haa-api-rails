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

var member_color = "02a1ce";
var scholar_color = "cf0435";
var countries_center = {US: [-87.928880, 41.480055], CA: [-95.099104, 60.263248]};
var map;
var layer = [];

function getDivIcon(count, type) {
  if (count < 10) {
    html = "<div class='" + type + "_cluster_icon' data-value='" + count + "'><div class='marker1'></div></div>";
  } else if (count < 100) {
    html = "<div class='" + type + "_cluster_icon' data-value='" + count + "'><div class='marker2'><div class='marker1'></div></div></div>";
  } else {
    html = "<div class='" + type + "_cluster_icon' data-value='" + count + "'><div class='marker3'><div class='marker2'><div class='marker1'></div></div></div></div>";
  }

  return new L.DivIcon({
    iconSize: [20, 20],
    html: html
  });
}

function refresh_map2(data) {
  var memberIcon = L.icon({
  	iconUrl: '/assets/member_marker.png',
  	iconSize: [9, 9]
  });
  var scholarIcon = L.icon({
  	iconUrl: '/assets/scholar_marker.png',
  	iconSize: [9, 9]
  });
  overlays = L.layerGroup().addTo(map);

  $.get("/get_search_results", data, function(response) {
    var members = response.members;
    var scholars = response.scholars;

    layer["members"] = new L.MarkerClusterGroup({
      iconCreateFunction: function(cluster) {
        count = cluster.getChildCount();
        return getDivIcon(count, "member");
      }
    });
    for (i = 0; i < members.length; i++) {
      var marker = L.marker(new L.LatLng(members[i].lat, members[i].lng), {
        icon: memberIcon,
        //icon: L.mapbox.marker.icon({'marker-symbol': 'marker', 'marker-color': member_color}),
      });
      layer["members"].addLayer(marker);
    }
    map.addLayer(layer["members"]);

    layer["scholars"] = new L.MarkerClusterGroup({
      iconCreateFunction: function(cluster) {
        count = cluster.getChildCount();
        return getDivIcon(count, "scholar");
      }
    });
    for (i = 0; i < scholars.length; i++) {
      var marker = L.marker(new L.LatLng(scholars[i].lat, scholars[i].lng), {
        icon: scholarIcon,
        //icon: L.mapbox.marker.icon({'marker-symbol': 'marker', 'marker-color': scholar_color}),
      });
      layer["scholars"].addLayer(marker);
    }
    map.addLayer(layer["scholars"]);

    if (typeof data.state != 'undefined') {

    } else {

    }

  });
}

function refresh_map(data) {
  $.get("/get_search_results", data, function(response) {
    var members = response.members;
    var scholars = response.scholars;

    for (i = 0; i < members.length; i++) {
      var el = document.createElement('div');
      el.className = 'member marker1';

      el.addEventListener('click', function() {
          //window.alert(marker.properties.message);
      });
      var marker = new mapboxgl.Marker(el);
      marker.setLngLat([members[i].lng, members[i].lat]);
      marker.addTo(map);
    }

    /*for (i = 0; i < scholars.length; i++) {
      var el = document.createElement('div');
      el.className = 'scholar marker1';

      el.addEventListener('click', function() {
          //window.alert(marker.properties.message);
      });
      var marker = new mapboxgl.Marker(el);
      marker.setLngLat([scholars[i].lng, scholars[i].lat]);
      marker.addTo(map);
    }*/

    if (typeof data.state != 'undefined') {

    } else {
      map.setCenter(countries_center[data.country]);
      map.flyTo(map.flyTo({
        center: [-95.099104, 60.263248],
        zoom: 9,
        speed: 0.2,
        curve: 1,
        easing(t) {
          return t;
        }
      }));

    }

  });
}
jQuery(document).on('turbolinks:load',function(){

  //map.scrollZoom.disable();

  var modal_options = {duration: 100, overlay: {fillColor: '#000', opacity: 0.68},
    offset: function() {
      // Fit the position to a button.
      var win = $(window);
      return {
        left:   (win.width() - parseInt(this.css('width'))) / 2,
        top: 54
      };
    }
  };

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

  $("#countries_dropdown").change(function(e) {

  });

  $("#states_dropdown").change(function(e) {
    coutry = $("#countries_dropdown option:selected").attr("country") == "US" ? "United States" : "Canada";
    data = {country: country, state: $("#states_dropdown").val()};
    refresh_map(data);

    data = {country: $("#countries_dropdown option:selected").attr("country"), state: $("#states_dropdown").val()};
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
    });
  });

  $("#cities_dropdown").change(function(e) {
    coutry = $("#countries_dropdown option:selected").attr("country") == "US" ? "United States" : "Canada";
    data = {
      country: country,
      state: $("#states_dropdown").val(),
      city: $("#cities_dropdown").val()
    };
    refresh_map(data);

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

  $('.history .sliders').slick({
    dots: true,
    centerMode: true,
    centerPadding: '145px',
    slidesToShow: 1,
    appendDots: $(".timeline"),
    customPaging : function(slider, i) {
        var data = $(".year_mark", slider.$slides[i]).text();
        return '<a class="slick-dot slick-dot-' + i + '">' + data + '</a>';
    },
  });

  $('.demographics .sliders').slick({
    dots: true,
    appendDots: $(".timeline"),
    customPaging : function(slider, i) {
        var year = 1950 + i * 10;
        return '<a class="slick-dot slick-dot-' + i + '">' + year + '</a>';
    },
  });

  $(".demographics .sublink").click(function(e) {
    return;
    if ($(this).hasClass("members_link")) {
      $(".demographics .scholars_link").removeClass("active");
      $(this).addClass("active");
    } else {
      $(".demographics .members_link").removeClass("active");
      $(this).addClass("active");
    }
    return false;
  });

  $(".color_bars > .bar").click(function(e) {
    $(this).toggleClass("checked");

    var value = $(this).attr("data-value");
    if ($(this).hasClass("checked")) {
      map.addLayer(layer[value]);
    } else {
      map.removeLayer(layer[value]);
    }
  });

});
