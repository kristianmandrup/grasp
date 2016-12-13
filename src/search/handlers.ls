replace = require '../replace'

module.exports =
  handle-count ->
    return unless @options.count
    @handle-display-filename! or @count-data!

  handle-replacement ->
    return unless @replacement?
    try
      # added actions :)
      replaced = replace @replacement, @clean-input, @search-results.sliced, @query-engine, @actions
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