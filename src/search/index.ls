Logger = require '../logger'
Handlers = require './handlers'
Setters = require './setters'

module.exports = class Search implements Logger, Handlers, Setters
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

  replace-pairs ->
    @options.to or @options.in-place

  count-data ->
    @out if @options.json or @data then @count else format-count @color, @count

  is-matching ->
    @options.files-with-matches and @count or @options.files-without-match and not @count

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
