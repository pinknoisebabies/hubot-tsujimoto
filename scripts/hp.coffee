var hpMax = 100;
var hpMin = 0;
var cron = require('cron').CronJob
var magic = require('magic.json');
var options = { room: 'random' };

module.exports = (robot) ->
  cron('0 0 9 * * 6', () ->
    var list = robot.brain.data;
    for(var key in list._private){
      robot.brain.set(key, hpMax);
    }
    robot.send(options, '全回復しました');

  robot.respond(/attack (\w+)/i, (msg) ->
    var user = msg.match[1];
    var damage = 10;
    var hp = attack(user, damage);
    msg.send(`${user}は攻撃された. ${damage}のダメージ！\nHP: ${hp}/${hpMax}`);

  robot.respond(/care (\w+)/i, (msg) ->
    var user = msg.match[1];
    var point = 10;
    var hp = care(user, point);
    msg.send(`${user}回復した. HP: ${hp}/${hpMax}`);

  robot.respond(/status/, (msg) ->
    var list = robot.brain.data;
    var status = new Array();
    for(var key in list._private){
      status.push(`${key} HP: ${list._private[key]}/${hpMax}`);
    }
    msg.send(status.join("\n"));

  robot.respond(/magic (\w+)/i, (msg) ->
    var user = msg.match[1];
    var magicNum = Math.floor(Math.random() * magic.length);
    var magicName = magic[magicNum].name;
    var damage = magic[magicNum].point;
    var hp = attack(user, damage);
    msg.send(`${user}は${magicName}で攻撃された. ${damage}のダメージ！\nHP: ${hp}/${hpMax}`);

  // タイムラインを全て形態素解析する
  robot.hear(/.*/, (msg) ->
    if ( ! msg.message.tokenized )
      return;

    var user = msg.message.user.name;
    var damage = 5;

    // ネガティブワードをキャッチする
    msg.message.tokenized.forEach((token) ->
      if ( /((疲|つか)れる)|((辛|つら)い)|((眠|ねむ)い)/.test(token.basic_form) )
        var hp = attack(user, damage);
        msg.send(`${user}は社会から攻撃を受けた！${damage}のダメージ！\nHP: ${hp}/${hpMax}`);

  attack(user, damage) ->
    var hp = robot.brain.get(user);
    hp = (hp !== null) ? hp : hpMax;
    hp = Math.max(hp - damage, hpMin);
    robot.brain.set(user, hp);
    return hp;

  care(user, point) ->
    var hp = robot.brain.get(user);
    hp = (hp !== null) ? hp : hpMax;
    hp = Math.min(hp + 10, hpMax);
    robot.brain.set(user, hp);
    return hp;
