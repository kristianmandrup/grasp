module.exports =
  parse-selector ->
    @parsed ?= {}
    @time 'parse-selector'
    @parsed.selector = @query-engine.parse @selector

  selector-from-file ->
    try
      @selector = @fs.read-file-sync that, 'utf8'
    catch
      @error "Error: No such file '#{@options.file}'."
      @exit 2
      return
    @targets = @positional

  selector-from-pos ->
    @selector = @positional.0
    @targets = @positional[1 to]