# Description:
#   Pobot tweets article of pocket regularly.
#
# Commands:
#   None
#
# Notes:
#   一時間に一回、Pocket APIを使ってPocketに保存されている記事をつぶきます。

cronJob = require('cron').CronJob

TOTAL_ARTICLES_NUM = 590  # 2014_1221

module.exports = (robot) ->
  cronTweet = new cronJob(
    cronTime: '00 00 0-23/1 * * *'
    start: false
    timeZone: 'Asia/Tokyo'
    onTick: ->
      offset = Math.floor((TOTAL_ARTICLES_NUM - 1) * Math.random())
      query = JSON.stringify({
        consumer_key: process.env.POCKET_CONSUMER_KEY,
        access_token: process.env.POCKET_ACCESS_TOKEN,
        state: 'all',
        count: 1,
        offset: offset
      })

      robot.http("https://getpocket.com/v3/get")
        .header('Content-Type', 'application/json')
        .post(query) (err, res, body) ->
          data = null
          try
            data = JSON.parse(body)
          catch error
            robot.logger.error "Ran into an error parsing JSON :("
            return

          for _, val of data.list
            bot_msg = "#{val.resolved_title} #{val.resolved_url}"
          envelope = room: 'Twitter'
          robot.logger.info "tweet regularly"
          robot.adapter.send envelope, "#{bot_msg}"
  )
  cronTweet.start()
