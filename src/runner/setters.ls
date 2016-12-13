module.exports =
  set-all ->
    @set-engine!
    @set-parser!
    @set-context!

    @set-output-format!

    @set-test-ext!
    @set-test-exclude!

  set-engine ->
    @query-engine = get-query-engine @options

  set-test-ext ->
    @test-ext = if exts.length is 0 or exts.length is 1 and exts.0 is '.'
      -> true
    else
      (.match //\.(?:#{ exts.join '|' })$//)

  set-test-exclude ->
    @test-exclude = if !@exclude or @exclude.length is 0
      -> true
    else
      @exclude-fun!

  set-output-format ->
    @color = Obj.map (-> if @options.color then it else (-> "#it")), @text-format{green, cyan, magenta, red}
    @bold = if @options.bold then @text-format.bold else (-> "#it")
    @text-format-funcs = {color, bold}

  set-parser ->
    [parser, parser-options] = switch options.parser.0
                              | 'acorn'   => [acorn, options.parser.1]
                              | otherwise => [require options.parser.0; options.parser.1]
    @parser = parser
    @parser-options = parser-options

  set-context ->
    @options.context ?= @options.NUM ? 0
    @options.before-context ?= @options.context
    @options.after-context ?= @options.context
