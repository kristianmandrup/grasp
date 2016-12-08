Logger = require '../logger'

module.exports = class Search implements Logger
  ({
    @console
    @call-callback
    @callback
    @options
    @parsed
    @parser-options
    @results = []
    @opts
  }) ->
    @search-results = {}
    @search-results.data = []
    @search-results.format = 'default'

    @out = !->
      @search-results.data.push it
      @callback it if @call-callback

  set-count ->
    @count = if @options.max-count? then min that, @results.length else @results.length

  set-results ->
    @search-results.sorted = sort-with @search-results.sort-func, @results
    @search-results.sliced = @search-results.sorted[til count]

  replace-pairs ->
    @options.to or @options.in-place

  handle-replacement ->
    return unless @replacement?
    try
      replaced = replace @replacement, @clean-input, @search-results.sliced, @query-engine
      if @replace-pairs?
        @@search-results.format := 'pairs'
        @out [name, replaced]
      else
        @out replaced
    catch
      @error "#name: Error during replacement. #{e.message}."

  handle-display-filename ->
    return unless @options.display-filename
    if @options.json or @data
      @@search-results.format := 'pairs'
      @out [@name, @count]
    else
      @out format-count @color, @count, @name

  count-data ->
    @out if @options.json or @data then @count else format-count @color, @count

  handle-count ->
    return unless @options.count
    @handle-display-filename! or @count-data!

  is-matching ->
    @options.files-with-matches and @count or @options.files-without-match and not @count

  # TODO: need txt format data, color etc.
  handle-file-matching ->
    return unless (@options.files-without-match or @options.files-with-matches)
    if @is-matching?
      @out if @options.json or @data then @name else format-name @color, @name

  handle-pairs ->
    return unless @options.display-filename
    @search-results.format := 'pairs'
    @out [@name, @search-results.sliced]

  handle-lists ->
    @search-results.format := 'lists'
    @out @search-results.sliced

  handle-json-data ->
    return unless (@options.json or @data)
    @handle-pairs! or @handle-lists!

  handle-input-data ->
    @input-lines = lines @clean-input
    for result in @search-results.sliced
      @out format-result @name, @input-lines, @input-lines.length, text-format-funcs, @options, @result

  handle-data ->
    @handle-json-data! or @handle-input-data!

  parse-input ->
    @clean-input = @input.replace /^#!.*\n/ ''
    try
      @time "parse-input:#name"
      @parsed.input = parser.parse @clean-input, parser-options
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
