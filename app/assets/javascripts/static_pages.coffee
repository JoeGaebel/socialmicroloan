scrollToBrowse = ->
  $('body,html').animate({scrollTop: $(".scroll-to").position().top + -40 }, 500);

onReady = ->
  $('.scrolling-link').on('click', scrollToBrowse)


$(document).on('turbolinks:load', onReady)
