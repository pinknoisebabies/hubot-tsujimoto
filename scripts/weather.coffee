module.exports = (robot) ->
  robot.hear /(.*)の天気教え(.*)/i, (msg) ->
    switch msg.match[1]
      when '今日'
        day = 0
      when '明日'
        day = 1
      when '明後日'
        day = 2
      else
        day = 3
        break
    a = 'http://weather.livedoor.com/forecast/webservice/json/v1?city=130010'
    request = msg.http(a)
    .get()
    request (err, res, body) ->
      json = JSON.parse body
      if day == 3
        forecast = 'わからんす'
      else
        forecast = json['forecasts'][day]['telop']
      msg.reply forecast
