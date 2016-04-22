http = require('http')
URL = 'http://api.jugemkey.jp/api/horoscope/free/2016/4/21'

http.get URL, (res) ->
  body = ''
  res.setEncoding('utf8')

  res.on('data', (chunk) ->
    body += chunk

  res.on('end', (res) ->
    res = JSON.parse body
    console.log res

horoscope.sort((a, b) =>
  console.log (a.rank < b.rank)
  return (a.rank > b.rank) ? -1 : 1
)
