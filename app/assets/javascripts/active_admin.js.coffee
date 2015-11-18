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
$ ->
  $('.fancybox').fancybox
    padding: 0
    type: 'ajax'
    closeBtn: true
    height: 'auto'
    scrolling: false
    arrows: false
    helpers:
      overlay:
        css:
          'background': 'rgb(58, 42, 45, 0.15)'
  return