#= require active_admin/base
#= require jquery-ui
#= require bootstrap
#= require bootstrap-multiselect
#= require fancybox
#= require jquery
#= require admin/jquery.flot
jQuery ->
  $('a.fancybox').fancybox('<h2>Hi!</h2><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam quis mi eu elit tempor facilisis id et neque</p>',
    {
      'autoDimensions': false,
      'width': 350,
      'height': 'auto',
      'transitionIn': 'none',
      'transitionOut': 'none'
    })