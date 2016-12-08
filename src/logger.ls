module.exports = Logger =
  time(txt) ->
    @console.time txt if @debug

  time-end(txt) ->
    @console.time-end txt if @debug

  log(txt) ->
    @console.log txt if @debug

  error(txt) ->
    @console.error txt
