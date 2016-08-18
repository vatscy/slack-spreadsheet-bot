request = require "request"

module.exports = (robot) ->
  robot.respond /.*/i, (res) ->
    res.send """

    【ルール】
    #インターン生の苗字（「さん」「くん」は自動でカットします）
    +または○を先頭につけると良い評価
    -または☓を先頭につけると悪い評価

    【例】
    #井上くん
    +自前のカメラで撮影している
    -もっと可愛く撮って

    【データ格納先】
    https://docs.google.com/spreadsheets/d/1Wfgqedap7LdKq8_w9uVQXWasDDg1FUN-ruvTu1LZ754/edit#gid=0
    ※ mti.internship.e1@gmail.com でログイン必要

    【注意】
    ・インターン生名と評価はセットで発言すること
    ・発言した後の編集は拾えません
    """

  robot.hear /^(#|＃)/i, (res) ->
    evaluatee = null

    rows = res.match["input"].split /\r\n|\r|\n/i
    for row in rows
      if !row
        continue
      else if /^(#|＃)/i.test row
        evaluatee = row.substr 1
        if /(くん|さん)$/i.test evaluatee
          evaluatee = evaluatee.slice 0, -2
        continue

      eva = ""
      if /^(\+|＋|○)/i.test row
        eva = "○"
      else if /^(\-|−|☓)/i.test row
        eva = "☓"
      else
        continue
      text = row.substr 1

      if evaluatee
        options =
          uri: "https://script.google.com/macros/s/AKfycbzhrxvTo0_5-W3k7hfbdMkvhV6N9nSP4ezQg5r1WuPwq1uUpZ-k/exec"
          json:
            evaluatee: evaluatee
            eva: eva
            text: text
            evaluator: res.message.user.name
        request.post options, (err, response, body) ->
          res.send "完了"

    res.send "#{rows}"
    #textArray = msg.message.split /\r\n|\r|\n/
  # やりたいこと
  # #, ＃から始まったらインターン生名
  # +, ＋, ○から始まったら良い評価
  # -, −, ☓から始まったら悪い評価
  # 最初にインターン生名がある
  # 一行で来るか、複数行で来るか
