window.CONST = 
  MAX_COUNT : 200
  ALLOW_DIFF : 0.5

$().ready ->
  autosize $('textarea')
  $('#calc').on 'click', calc


calc = ->
  percents = []
  for p in $('#percents').val().split("\n")
    pf = parseFloat p
    percents.push(pf) unless Utl.inArray pf, percents
  scores = []
  for max in [2..window.CONST.MAX_COUNT]
    score = 0
    for p in percents
      tempScore = 0
      tempScored = false
      for m in [1..max]
        pM = (m / max) * 100
        if window.CONST.ALLOW_DIFF < Math.round(pM - p)
          break
        else if Math.abs(pM - p) <= window.CONST.ALLOW_DIFF
          if not tempScored or Math.abs(pM - p) < tempScore
            tempScore = Math.abs(pM - p)
            tempScored = true
      if tempScored
        score += tempScore
      else
        score = false
        break
    scores.push [max, (if score is false then false else score/max)]

  scores.sort (a, b)->
    return 1 if a[1] is false and b[1] isnt false
    return -1 if a[1] isnt false and b[1] is false
    return a[1] - b[1] if a[1] - b[1] isnt 0
    a[0] - b[0]

  $('#result tbody').html('')
  for s in scores
    $('#result tbody').append(
      $('<tr>').append(
        $('<td>').html(''+s[0]+'人')
      ).append(
        $('<td>').html(s[1])
      )
    )

bookmarklet = ->
  percents = document.body.innerText.match(/(\d+)(\.\d+)?[%％]/g)
  percents.join("\n")