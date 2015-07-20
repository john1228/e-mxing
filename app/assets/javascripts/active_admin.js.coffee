#= require active_admin/base
#= require jquery-ui
#= require bootstrap
#= require bootstrap-multiselect
#= require fancybox
#= require jquery
#= require admin/jquery.flot
jQuery ->
  $('a.fancybox').fancybox(
    {
      padding: 0,
      autoScale: true
    }
  )