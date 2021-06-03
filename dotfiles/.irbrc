IRB.conf[:SAVE_HISTORY] = 200
IRB.conf[:HISTORY_FILE] = '~/.irb_history'

def json_pp(json)
  puts JSON.pretty_generate(JSON.parse(json))
end
