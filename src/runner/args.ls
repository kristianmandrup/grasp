module.exports =
  parse-args ->
    try
      {_: positional, debug}:options = parse-options @args
      @options = options
      @positional = positional or []
      @debug = debug
    catch
      @error e.message
      @exit 2
      return

  validate-args ->
    unless @args?
      @error 'Error: Must specify arguments.'
      @exit 2
      return

  extract-opts ->
    @options.display-filename = get-display-filename @options, @targets
    @exts = @options.extensions
    @exclude = @options.exclude
    @call-callback = not @options.quiet and not @options.json and not @options.to and not @options.in-place
