cron = require('cron').CronJob
TWIT = require "twit"
MENTION_ROOM = process.env.HUBOT_TWITTER_MENTION_ROOM || "random"
MAX_TWEETS = 5

config =
  consumer_key: process.env.HUBOT_TWITTER_CONSUMER_KEY
  consumer_secret: process.env.HUBOT_TWITTER_CONSUMER_SECRET
  access_token: process.env.HUBOT_TWITTER_ACCESS_TOKEN_KEY
  access_token_secret: process.env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET

getTwit = ->
  unless twit
    twit = new TWIT config

module.exports = (robot) ->
  new cron '0 0 * * * *', () ->
    robot.brain.on 'loaded', =>
      robot.brain.data.last_tweet ||= '1'
      doAutomaticSearch(robot)

  doAutomaticSearch = (robot) ->
    query = process.env.HUBOT_TWITTER_MENTION_QUERY
    since_id = robot.brain.data.last_tweet
    count = MAX_TWEETS

    twit = getTwit()
    twit.get 'search/tweets', {q: query, count: count, since_id: since_id}, (err, data) ->
      if err
        console.log "Error getting tweets: #{err}"
        return
      if data.statuses? and data.statuses.length > 0
        robot.brain.data.last_tweet = data.statuses[0].id_str
        for tweet in data.statuses.reverse()
          message = "Tweet Alert: http://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id_str}"
          robot.messageRoom MENTION_ROOM, message
