onReady = ->
  $('#campaign_support_support_amount').on('keydown keyup', onSupportAmountKey)
  $('#campaign_support_require_interest').bind 'click', toggleInterestReceived

toggleInterestReceived = (e) ->
  pane = $('.with-interest')
  pane.toggleClass('hidden')
  updateAmounts()


onSupportAmountKey = (e) ->
  if !utils.restrictNegatives(e)
    return false

  utils.restrictAmountTo(e, window.maxSupportAmount)
  updateAmounts()

updateAmounts = ->
  requireInterest = $('#campaign_support_require_interest').is(':checked')

  campaignInterest = $('#campaign_interest').val()
  supportAmount = $('#campaign_support_support_amount').val()
  repaymentLength = $('#campaign_repayment_length').val()

  revenue = campaignInterest / 100 * supportAmount

  interestPercent = campaignInterest / 100
  totalPayback = supportAmount
  totalPayback *= (1 + interestPercent) if requireInterest

  monthlyRepayment = totalPayback / repaymentLength;

  $('.revenue-amount').text(revenue.toFixed(2))
  $('.payback-amount').text(monthlyRepayment.toFixed(2))

$(document).on('turbolinks:load', onReady)
