module.exports = (robot) ->
  robot.receive = (msg) ->
    console.log msg

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
    if /hoge/.test(text)
      date = Date.now()
      robot.logger.info "reply #{user_name}!"
      robot.adapter.reply envelope.tweet, "ほげほげ - #{date}"
