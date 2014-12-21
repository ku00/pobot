# Description:
#   Pobot replies one article of Pocket.
#
# Commands:
#   ぽけっと(ポケット, pocket) - You reply with one article of Pocket When you post a "ぽけっと" word.
#
# Notes:
#   Pocket APIを使ってPocketに保存されている記事を返します。
#   なお、知らない人には平井神様AAを返します。

TOTAL_ARTICLES_NUM = 590  # 2014_1221
PARISON_AA = '''

      　　　 ／⌒ヽ　　
      　　　(平ω井)　＜ さっぱりぞんだ…
      　＿ノ ヽ　ノ ＼＿
      `/　`/ ⌒Ｙ⌒ Ｙ　 ヽ
      ( 　(三ヽ人　 /　　 | 
      |　ﾉ⌒＼ ￣￣ヽ　 ノ 
      ヽ＿＿＿＞､＿＿_／ 
      　　 ｜( 王 ﾉ〈 

'''

module.exports = (robot) ->
  robot.receive = (msg) ->
    user_id = msg.user.id
    user_name = msg.user.name
    status_id = msg.id

    envelope = {
      tweet : { 
        room: 'Twitter',
        user: { id: user_id, name: user_name, room: 'Twitter' },
        message: {
          user: { id: user_id, name: user_name, room: 'Twitter' },
          text: 'hello hubot...',
          id: status_id,
          done: false,
          room: 'Twitter'
        }
      }
    }

    text = msg.text

    if /(ぽけっと|ポケット|pocket)/.test(text)
      unless user_name == process.env.MASTER_USER
        robot.logger.info "reply #{user_name}! ぱりぞん"
        robot.adapter.reply envelope.tweet, "#{PARISON_AA}"
        return

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
          robot.logger.info "reply #{user_name}! pocket"
          robot.adapter.reply envelope.tweet, "#{bot_msg}"
