onReady = ->
  $('#campaign_support_support_amount').on('keydown keyup', onSupportAmountKey)
  $('#campaign_support_require_interest').bind 'click', toggleInterestReceived

toggleInterestReceived = (e) ->
  pane = $('.with-interest')
  pane.toggleClass('hidden')
  updateAmounts()


onSupportAmountKey = (e) ->
  if(!((e.keyCode > 95 && e.keyCode < 106) || (e.keyCode > 47 && e.keyCode < 58) || e.keyCode == 8))
    return false

  supportAmount = $(e.target)
  if supportAmount.val() > window.maxSupportAmount
    supportAmount.val(window.maxSupportAmount)

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


$(document).ready(onReady)
$(document).on('page:load', onReady)
