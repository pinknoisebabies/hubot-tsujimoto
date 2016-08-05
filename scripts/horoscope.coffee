cron = require('cron').CronJob

module.exports = (robot) ->
  new cron '0 0 10 * * 1-5', () ->
    user = {room: 'random'}
    countDown(robot)
  , null, true

  robot.hear /(.*)今日の占いカウントダウン(.*)/i, (msg) ->
    countDown(msg)

  countDown = (msg) ->
    d = new Date
    year = d.getFullYear() # 年（西暦）
    month = ('0' + (d.getMonth() + 1)).slice( -2 ) # 月
    day = d.getDate() # 日

    request = msg.http("http://api.jugemkey.jp/api/horoscope/free/#{year}/#{month}/#{day}").get()
    request (err, res, body) ->
      json = JSON.parse body
      today = json['horoscope']["#{year}/#{month}/#{day}"]

      today.sort (a, b) -> b.rank - a.rank

      for val in today
        msg.send val.rank + "位: " + val.sign + " ラッキーカラー: " + val.color + " ラッキーアイテム: " + val.item
