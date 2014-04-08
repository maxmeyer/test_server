//= require jquery
//= require bootstrap-sass/dist/js/bootstrap

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
  var timeout = escapeHTML($('#timeout').val() * 1000);
  var count   = escapeHTML($('#count').val());
  var repeat  = escapeHTML($('#hidden_repeat').val());

  var requests = [];

  var success_callback = function() {
    $('#request-spinner').toggle(false);

    if (repeat == 'true') {
      setTimeout(repeat_requests(), 1000);
    }
  };

  var failure_callback = function() {
    $('#request-spinner').toggle(false);

    if (repeat == true) {
      setTimeout(repeat_requests(url, count, timeout), 1000);
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
