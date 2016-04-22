module.exports = (robot) ->
  robot.hear /(.*)今日の占いカウントダウン(.*)/i, (msg) ->
    d = new Date
    year = d.getFullYear() # 年（西暦）
    month = ('0' + (d.getMonth() + 1)).slice( -2 ) # 月
    day = d.getDate() # 日

    request = msg.http("http://api.jugemkey.jp/api/horoscope/free/#{year}/#{month}/#{day}").get()
    request (err, res, body) ->
      json = JSON.parse body
      today = json['horoscope']["#{year}/#{month}/#{day}"]
      today.sort((a, b) ->
        return (a.rank > b.rank) ? -1 : 1
      )

      message = ""
      for val in today
        message += (val.rank + "位: " + val.sign + " ラッキーカラー: " + val.color + " ラッキーアイテム: " + val.item + "\n")

      msg.send message
