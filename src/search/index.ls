Logger =
  time(txt) ->
    @console.time txt if @debug

  time-end(txt) ->
    @console.time-end txt if @debug

  log(txt) ->
    @console.log txt if @debug

  error(txt) ->
    @console.error txt

module.exports = class Search implements Logger
  ({
    @console, @call-callback, @options, @parsed
  }) ->
    @results-data = []
    @results-format = 'default'

    @out = !->
      @results-data.push it
      callback it if @call-callback

  set-count ->
    @count = if @options.max-count? then min that, @results.length else @results.length

  set-results ->
    sorted-results = sort-with results-sort-func, @results
    @sliced-results = sorted-results[til count]

  handle-replacement ->
    return if not @replacement?
    try
      replaced = replace replacement, clean-input, sliced-results, query-engine
      if options.to or options.in-place
        @results-format := 'pairs'
        @out [name, replaced]
      else
        @out replaced
    catch
      @error "#name: Error during replacement. #{e.message}."

  handle-count ->
    return if not @options.count
    if @options.display-filename
      if @options.json or data
        @results-format := 'pairs'
        @out [name, count]
      else
        @out format-count color, count, name
    else
      @out if @options.json or data then count else format-count color, count

  # TODO: need txt format data, color etc.
  handle-file-matching ->
    return if not (@options.files-without-match or @options.files-with-matches)
    if @options.files-with-matches and count or @options.files-without-match and not count
      @out if @options.json or data then name else format-name color, name

  handle-json-data ->
    return if not (@options.json or data)
    if @options.display-filename
      @results-format := 'pairs'
      @out [@name, @sliced-results]
    else
      @results-format := 'lists'
      @out @sliced-results

  handle-input-data ->
      input-lines = lines @clean-input
      for result in @sliced-results
        @out format-result name, input-lines, input-lines.length, text-format-funcs, options, result

  handle-data ->
    @handle-json-data! or @handle-input-data!

  parse-input ->
    @clean-input = @input.replace /^#!.*\n/ ''
    try
      @time "parse-input:#name"
      @parsed.input = parser.parse clean-input, parser-options
      @time-end "parse-input:#name"
      if @options.print-ast
          @log JSON.stringify @parsed.input, null, 2
    catch
      throw new Error "Error: Could not parse JavaScript from '#name'. #{e.message}"

  query ->
    @time "query:#name"
    @results = @query-engine.query-parsed @parsed.selector, @parsed.input
    @time-end "query:#name"

  search(@name, @input) !->
    @time "search-total:#name"
    @parse-input!
    @query!

    @set-count!
    @set-results!

    @handle-replacement! or @handle-count! or @handle-file-matching! or handle-data!

    @time-end "search-total:#name"
