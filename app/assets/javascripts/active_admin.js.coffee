#= require active_admin/base
#= require bootstrap
#= require bootstrap-multiselect
#= require fancybox
#= require jquery
#= require jquery-ui
#= require jquery-ui-timepicker-addon
#= require admin/jquery.flot
#= require admin/PCASClass
#= require admin/fileinput_locale_zh
#= require admin/fileinput
jQuery -> $('a.fancybox').fancybox(
  {
    modal: false,
    scrolling: false
  }
);
$("input.datetimepicker").datetimepicker({
  stepMinute: 30
  dateFormat: "yy-mm-dd"
})
