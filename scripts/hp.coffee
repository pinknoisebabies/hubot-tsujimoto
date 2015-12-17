hpMax = 100
hpMin = 0
cron = require('cron').CronJob
options = { room: 'random' }

magic =
    0:
      "name": 'サンダー'
      "point": 5
    1:
      "name": 'ファイアー'
      "point": 5
    2:
      "name": 'ウォータ'
      "point": 5
    3:
      "name": 'ブリザド'
      "point": 5
    4:
      "name": 'サンダガ'
      "point": 20
    5:
      "name": 'ファイガ'
      "point": 20
    6:
      "name": 'ウォータガ'
      "point": 20
    7:
      "name": 'ブリザガ'
      "point": 20

module.exports = (robot) ->
  cron '0 0 9 * * 6', () ->
    list = robot.brain.data
    for key in list._private
      robot.brain.set(key, hpMax)
    robot.send options, '全回復しました'

  robot.respond /attack (\w+)/i, (msg) ->
    user = msg.match[1]
    damage = 10
    hp = attack user, damage
    msg.send "#{user}は攻撃された. #{damage}のダメージ！\nHP: #{hp}/#{hpMax}"

  robot.respond /care (\w+)/i, (msg) ->
    user = msg.match[1]
    point = 10
    hp = care user, point
    msg.send "#{user}回復した. HP: #{hp}/#{hpMax}"

  robot.respond /status/, (msg) ->
    list = robot.brain.data
    status = []
    for key in list._private
      status.push "#{key} HP: #{list._private[key]}/#{hpMax}"
    msg.send (status.join "\n")

  robot.respond /magic (\w+)/i, (msg) ->
    user = msg.match[1]
    magicNum = Math.floor(Math.random() * magic.length)
    magicName = magic[magicNum].name
    damage = magic[magicNum].point
    hp = attack user, damage
    msg.send "#{user}は#{magicName}で攻撃された. #{damage}のダメージ！\nHP: #{hp}/#{hpMax}"

  robot.hear /.*/, (msg) ->
    if !msg.message.tokenized
      return

    user = msg.message.user.name
    damage = 5

    msg.message.tokenized.forEach (token) ->
      if /((疲|つか)れる)|((辛|つら)い)|((眠|ねむ)い)/.test token.basic_form
        hp = attack user, damage
        msg.send "#{user}は社会から攻撃を受けた！#{damage}のダメージ！\nHP: #{hp}/#{hpMax}"

  attack = (user, damage) ->
    hp = robot.brain.get user
    if hp == null
      hp = hpMax
    hp = Math.max(hp - damage, hpMin)
    robot.brain.set user, hp
    return hp

  care = (user, point) ->
    hp = robot.brain.get user
    if hp == null
      hp = hpMax
    hp = Math.min(hp + 10, hpMax)
    robot.brain.set user, hp
    return hp
