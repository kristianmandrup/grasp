do-each = (args, result) ->
  switch args.0
  | 'before' =>
    for result in results
      result.raw.prepend = "#{args.1}#{ result.raw.prepend ? ''}"
  | 'after' =>
    for result in results
      result.raw.append = "#{ result.raw.append ? ''}#{args.1}"
  | 'wrap' =>
    [pre, post] = if args.length is 2 then [args.1, args.1] else [args.1, args.2]
    for result in results
      result.raw.prepend = "#{pre}#{ result.raw.prepend ? ''}"
      result.raw.append = "#{ result.raw.append ? ''}#{post}"
  | otherwise =>
    throw new Error "'#{args.0}' is not supported by 'each'"

append = (results, arg) ->
  results.push type: 'Raw', raw: "#arg"

prepend = (results, arg) ->
  results.unshift type: 'Raw', raw: "#arg"

module.exports =
  prepend ->
    for arg in args then prepend @results, arg
  append ->
    for arg in args then append @results, arg
  each ->
    throw new Error "No arguments supplied for 'each #{@args.0}'" if @args.length < 2
    do-each @args, @result
  nth ->
    n = +@args.0
    @results := @results.slice n, (n + 1)
  nth-last ->
    n = @results.length - +@args.0 - 1
    @results := @results.slice n, (n + 1)
  first ->
    @results := @results.slice 0, 1
  tail ->
    @results := @results.slice 1
  last ->
    len = @results.length
    @results := @results.slice (len - 1), len
  initial ->
    @results := results.slice 0, (results.length - 1)
  slice ->
    @results := [].slice.apply results, args
  reverse ->
    @results.reverse!