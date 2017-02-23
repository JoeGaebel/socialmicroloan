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

onGoalAmountKey = (e) ->
  if !utils.restrictNegatives(e)
    return false
  utils.restrictAmountTo(e, window.maxLoanAmount)

onPercentKey = (e) ->
  if !utils.restrictNegatives(e)
    return false

  utils.restrictAmountTo(e, window.maxInterest)

checkFileSize = ->
  file = @files[0]
  size_in_megabytes = file.size / 1024 / 1024
  if size_in_megabytes > 5
    alert 'Maximum file size is 5MB. Please choose a smaller file.'

hideIcon = ->
  $('.load-icon').hide()

chooseFile = ->
  $('#campaign_picture').click()

updateDisplayAmounts = ->
  totalAmount = $('.total-amount')
  montlyPayment = $('.monthly-payment')

  goalAmount = $('#campaign_goal_amount').val()
  interestPercent = $('#campaign_interest_percent').val()
  repaymentLength = $("input:radio[name='campaign[repayment_length]']:checked").val()

  goalAmount = parseInt(goalAmount)
  interestPercent = parseInt(interestPercent)
  repaymentLength = parseInt(repaymentLength)


  if goalAmount and interestPercent
    interestAmount = interestPercent / 100
    totalAmountValue = goalAmount * (1 + interestAmount)
    monthlyPaymentValue = totalAmountValue / repaymentLength

    totalAmount.text(totalAmountValue.toFixed(2))
    montlyPayment.text(monthlyPaymentValue.toFixed(2))

onReady = ->
  $('#campaign_goal_amount').on('keydown keyup', onGoalAmountKey)
  $('#campaign_interest_percent').on('keydown keyup', onPercentKey)

  $('#campaign_goal_amount').on('keydown keyup', updateDisplayAmounts)
  $('#campaign_interest_percent').on('keydown keyup', updateDisplayAmounts)
  $('.repayment-length').on('change', updateDisplayAmounts)

  $('#loaded_picture').bind 'click', chooseFile

  loadedDate = $('#campaign_goal_date').val()
  $('#campaign_goal_date').datepicker({
    dateFormat: "yy-mm-dd"
  })

  $('#campaign_picture')
    .change(checkFileSize)
    .change(showPicture)
    .change(hideIcon)

$(document).on('turbolinks:load', onReady)
