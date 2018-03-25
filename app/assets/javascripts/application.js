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
  	iconUrl: 'http://horatio-api-staging.herokuapp.com/member_marker.png',
  	iconSize: [9, 9]
  });
  var scholarIcon = L.icon({
  	iconUrl: 'http://horatio-api-staging.herokuapp.com/scholar_marker.png',
  	iconSize: [9, 9]
  });

  $.get("/get_search_results", data, function(response) {
    var members = response.members;
    var scholars = response.scholars;
    var scholarships = response.scholarships;
    var selected_state = response.selected_state;
    var mapdata = {"members": members, "scholars": scholars}

    clearMap();

    $("#total_members").text(members.length);
    $("#total_scholars").text(numeral(scholars.length).format('0,0'));
    $("#total_scholarships").text(numeral(scholarships).format('($0.00a)'));

    if (typeof data.state != 'undefined' && selected_state.length > 0) {
      map.flyTo(L.latLng(selected_state[0].lat, selected_state[0].lng),6);
    }

    layer["members"] = new L.MarkerClusterGroup({
      showCoverageOnHover: false,
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
      showCoverageOnHover: false,
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
      // adding data to left side panel
      if (typeof data.city != 'undefined') {
        selected_location = data.city + ", " + data.state;
      } else {
        selected_location = response.selected_state[0].name;
      }
      $(".stats_panel").html("");
      k = 0;
      for (var type in mapdata) {

        member_rows = "";
        for (i = 0; i < mapdata[type].length; i++) {
          member_rows += ' \
            <div class="member_row"> \
              <div class="name">' + mapdata[type][i].full_name + '</div> \
              <div class="location">' + mapdata[type][i].city + ", " + mapdata[type][i].state + '</div> \
            </div> \
          ';
        }

        count = mapdata[type].length;
        if (k == 0) {
          open = "open";
        } else {
          open = "";
        }
        html = ' \
          <div class="panel ' + type + '_panel ' + open + '"> \
            <div class="panel_header"> \
              <div class="header_bar"></div> \
              <div class="state_name">' + selected_location + '</div> \
            </div> \
            <div class="count_info"> \
              <div class="count">' + count + ' ' + type + '</div> \
              <a class="toggle_collapse"></a> \
            </div> \
            <div class="panel_body">' + member_rows + '</div> \
          </div> \
        ';
        $(".stats_panel").append(html);
        k++;
      }

      $('.stats_panel .panel_body').scrollbar();
      $(".stats_panel").fadeIn();
    }

  });
}

function clearMap() {
  for (key in layer) {
    layer[key].clearLayers();
  }
}

jQuery(document).on('turbolinks:load', function() {

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

  // $(".goback").click(function(e) {
  //   window.history.back();
  //   return false;
  // });

  $("#countries_dropdown").change(function(e) {

  });

  $("#states_dropdown").change(function(e) {
    country = $("#countries_dropdown option:selected").attr("country") == "US" ? "United States" : "Canada";
    data = {country: country, state: $("#states_dropdown").val()};
    refresh_map2(data);

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
    refresh_map2(data);

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
        return '<a class="slick-dot slick-dot-' + i + '">' + data.substring(0,4) + '</a>';
    },
  });

  $('.history .inner-slider').slick({
    swipe: false,
    speed: 500,
    fade: true,
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

  $(document).on("click", ".toggle_collapse", function(e) {
    var panel = $(this).closest(".panel");

    if (panel.hasClass("open")) {

    } else {
      $(".stats_panel > .panel").removeClass("open");
    }

    panel.toggleClass("open");
    panel.parent().prepend(panel);

  });
});
