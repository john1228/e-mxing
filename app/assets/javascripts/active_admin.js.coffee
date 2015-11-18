#= require bootstrap
#= require bootstrap-multiselect
#= require active_admin/base
#= require jquery-ui
#= require jquery-ui-timepicker-addon
#= require admin/jquery.flot
#= require admin/PCASClass
#= require fancybox
$ ->
  $('a.fancybox').fancybox
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