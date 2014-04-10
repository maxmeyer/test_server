// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sass/dist/js/bootstrap
//= require_tree .

function escapeHTML(s) {
  return String(s).replace(/&(?!\w+;)/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

function result(url, timeout, start_time, result) {
  var end_time = new Date().getTime();
  var run_time = end_time - start_time;

  if ( result == 'ok') {
    var result_klass = 'ts-result-successfull-request';
  } else {
    var result_klass = 'ts-result-failed-request';
  }

  $('#result').toggle(true);
  $('#result_table_header').after('<tr class="ts-result-row ' + result_klass + '"><td>' + url + '</td><td>' + timeout + '</td><td>' + run_time + '</td><td>' + result + '</td></tr>');
  
}

$(document).ready(function(){
  $("#clone").click(function () {

    set_repeat();

    var open_time = new Date().getTime();
    window.open(window.location.pathname + '?' + $('form').serialize(), '_blank');
  });
});

$(document).ready(function(){
  $("#reset").click(function () {
    $('#form')[0].reset();
    $('.ts-result-row').remove();
    $('#result').toggle(false);
  });
});

function set_repeat() {
  var repeat  = $('#repeat').is(":checked");

  if (repeat == true) {
    $('#hidden_repeat').val('true');
  } else {
    $('#hidden_repeat').val('false');
  }
}

$(document).ready(function(){
  $("#stop").click(function (e) {
    e.preventDefault();
    $('#hidden_repeat').val('false');
  });
});

$(document).ready(function(){
  $("#start").click(function (e) {
    e.preventDefault();
    set_repeat();
    repeat_requests();
  });
});

function repeat_requests() {
  var url     = escapeHTML($('#url').val());
  var timeout = escapeHTML($('#timeout').val());
  var count   = escapeHTML($('#count').val());
  var repeat  = escapeHTML($('#hidden_repeat').val());

  var requests = [];

  var success_callback = function() {
    $('#request-spinner').toggle(false);

    if (repeat == 'true') {
      setTimeout(repeat_requests(), 2000);
    }
  };

  var failure_callback = function() {
    $('#request-spinner').toggle(false);

    if (repeat == 'true') {
      setTimeout(repeat_requests(), 2000);
    }
  };

  $('#request-spinner').toggle(true);

  for(i = 0; i < count; i++) {
    requests.push(sendAjax(url, timeout));
  }

  $.when.apply(undefined, requests).then(function(results){success_callback()}, function(results){failure_callback()});
}

function sendAjax(url, timeout)  {
  var start_time = new Date().getTime();

  return $.ajax(
      {
        url: url,
         timeout: timeout,
         cache: false, 
         success: function() {
           result(url, timeout, start_time, 'ok');
         },
         error: function(){
           result(url, timeout, start_time, 'fail');
         }
      }
  );
}
