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

function result(url, start_time, result) {
  var end_time = new Date().getTime();
  var run_time = end_time - start_time;
  if ( result == 'ok') {
    var result_klass = 'ts-result-successfull-request';
  } else {
    var result_klass = 'ts-result-failed-request';
  }

  $('#result').toggle(true);
  $('#result tr:last').after('<tr class="' + result_klass + '"><td>' + url + '</td><td>' + run_time + '</td><td>' + result + '</td></tr>');
}

$(document).ready(function(){
  $("#reset").click(function () {
    $('#form')[0].reset();
  });
});

$(document).ready(function(){
  $("#submit").click(function (e) {
    e.preventDefault();

    var url     = escapeHTML($('#url').val())
    var timeout = escapeHTML($('#timeout').val())
    var count   = escapeHTML($('#count').val())

    for (var i = 0, limit = count ; i < limit; i++) {

      var start_time = new Date().getTime();

      $.ajax({
        url: url,
        timeout: timeout,
        cache: false, 
        success: function() {
          result(url, start_time, 'ok');
        },
        error: function(){
          result(url, start_time, 'fail');
        }
      });
    }

  });
});
