module.exports = (robot) ->
  robot.hear /(.*)今日の占いカウントダウン(.*)/i, (msg) ->
    d = new Date
    year = d.getFullYear() # 年（西暦）
    month = d.getMonth() + 1 # 月
    day = d.getDate() # 日

    request = msg.http("http://api.jugemkey.jp/api/horoscope/free/#{year}/#{month}/#{day}").get()
    request (err, res, body) ->
      json = JSON.parse body
      forecast = json['horoscope']["#{year}/#{month}/#{day}"][0]['sign']
      msg.reply forecast
