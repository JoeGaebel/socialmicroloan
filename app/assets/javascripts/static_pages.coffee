scrollToBrowse = ->
  $("body").animate({scrollTop: $(".scroll-to").position().top + -40 }, 300);

onReady = ->
  $('.scrolling-link').on('click', scrollToBrowse)


$(document).on('turbolinks:load', onReady)
