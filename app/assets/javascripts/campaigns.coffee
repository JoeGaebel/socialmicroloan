showPicture = ->
  file = @files[0]
  return unless file.type.match('image.*')

  reader = new FileReader
  reader.onload = (->
    (e) ->
      $('#loaded_picture').prop 'src', e.target.result
      return
  )(file)

  reader.readAsDataURL file

checkFileSize = ->
  file = @files[0]
  size_in_megabytes = file.size / 1024 / 1024
  if size_in_megabytes > 5
    alert 'Maximum file size is 5MB. Please choose a smaller file.'

hideIcon = ->
  $('.load-icon').hide();

chooseFile = ->
  $('#campaign_picture').click();


onReady = ->
  $('#loaded_picture').bind 'click', chooseFile
  $('#campaign_goal_date').datepicker()
  $('#campaign_picture')
    .change(checkFileSize)
    .change(showPicture)
    .change(hideIcon)


$(document).ready(onReady)
$(document).on('page:load', onReady)
