#= require active_admin/base
#= require bootstrap
#= require bootstrap-multiselect
#= require jquery
#= require jquery-ui
#= require jquery-ui-timepicker-addon
#= require admin/jquery.flot
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
  })