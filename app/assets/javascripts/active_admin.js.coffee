#= require jquery
#= require jquery-ui
#= require jquery-ui-timepicker-addon
#= require bootstrap-sprockets
#= require bootstrap
#= require bootstrap-multiselect
#= require admin/bootstrap-tab
#= require fancybox
#= require admin/PCASClass
#= require admin/fileinput_locale_zh
#= require admin/fileinput
$ ->
  $('a.fancybox').fancybox({
    padding: 0
    type: 'ajax'
    closeBtn: true
    height: 'auto'
    scrolling: false
    arrows: false
  });
  $("input.datetimepicker").datetimepicker
  stepMinute: 30
  dateFormat: "yy-mm-dd"