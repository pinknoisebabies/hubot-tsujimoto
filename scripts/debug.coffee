# request = require('request')

d = new Date
year = d.getFullYear() # 年（西暦）
month = d.getMonth() + 1 # 月
date = d.getDate() # 日
console.log('http://api.jugemkey.jp/api/horoscope/free/#{year}/#{month}/#{date}')
console.log("#{year}")

# request = msg.http('http://api.jugemkey.jp/api/horoscope/free/' + year + '/' + month + '/' + date).get()
