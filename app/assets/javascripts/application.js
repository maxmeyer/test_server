//= require jquery
//= require bootstrap-sass/dist/js/bootstrap

//$(document).ready(function(){
//  $(".lp_show_fields").click(function(e){
//    e.preventDefault()
//    $(".lp_fields_close, .lp_fields_open").toggle();
//    $(".lp_button_show_fields_close, .lp_button_show_fields_open").toggle();
//  });
//});

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
  $("#reset").click(function () {
    $('#form')[0].reset();
    $('.ts-result-row').remove();
  });
});

$(document).ready(function(){
  $("#submit").click(function (e) {
    e.preventDefault();

    var url     = escapeHTML($('#url').val());
    var timeout = escapeHTML($('#timeout').val() * 1000);
    var count   = escapeHTML($('#count').val());

    repeat_requests(url, count, timeout);
  });
});

function repeat_requests(url, count, timeout) {
  var repeat  = $('#repeat').is(":checked");
  var requests = [];

  var callback = function() {
    console.log("done");

    if (repeat == true) {
      console.log("repeating");
      setTimeout(repeat_requests(url, count, timeout), 1000);
    }
  };

  for(i = 0; i < count; i++) {
    requests.push(sendAjax(url, timeout));
  }

  $.when.apply(undefined, requests).then(function(results){callback()});
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

$('#notification').modal('hide');

//var mySpinner = {
//  hide : function () {
//    jQuery('#request-spinner').hide();
//  }
//};
//
//$.when(
//  $.ajax("/first"),
//  $.ajax("/second"),
//  "any-other-javascript-object")
//.then(
//  mySpinner.hide,  // yourSuccessFunction
//  mySpinner.hide); // yourFailureFunction
//});
//
