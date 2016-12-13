module.exports =
  start-debug ->
    @time 'everything'
    @log 'options:'
    @log options

  end-debug ->
    @time-end 'parse-selector'
    @log 'parsed-selector:'
    @log JSON.stringify @parsed.selector, null, 2