window.utils =
  restrictNegatives: (e) ->
    if(!((e.keyCode > 95 && e.keyCode < 106) || (e.keyCode > 47 && e.keyCode < 58) || e.keyCode == 8))
      return false
    else
      return true

  restrictAmountTo: (e, maxAmount) ->
    actualAmount = $(e.target)
    if actualAmount.val() > maxAmount
      actualAmount.val(maxAmount)
