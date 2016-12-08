version = require('../package.json').version

{ search-target, get-query-engine, get-display-filename } = require './utils'

Logger = require '../logger'
search = require '../search'

class Runner implements Logger
  ({
  @opts
  @args
  @error = -> throw new Error it
  @callback = ->
  @exit = ->
  @data = false
  @stdin
  @fs = require 'fs'
  @text-format = require 'cli-color'
  @input
  @console = _console
  } = {}) ->
    @validate-args!
    @parse-args!
    @extract-opts!

    @start-debug!
    @handle-version!
    @handle-help!
    @handle-jsx!
    @query-engine = get-query-engine @options
    @set-parser!
    @set-context!
    @handle-file!
    @handle-recursive!
    @handle-replace!
    @handle-selector!

    @options.display-filename = get-display-filename @options, @targets

    @set-output-format!
    @prepare-search!

    @parse-selector!
    @end-debug!

  run ->
    @set-test-ext!
    @set-test-exclude!
    @do-search!

  search-input ->
    return unless @input
    @search '(input)', @input
    @results-format = @search.results-format
    @end ['-'] # as if stdin for replacement

  search-targets ->
    cwd = process.cwd!
    async.each-series @targets, (search-target cwd, cwd), -> end @target-paths
    void

  do-search ->
    @target-paths = []
    @search-input! or @search-targets!

  prepare-search ->
    @search = new Search {
      @console
      @parsed
      @parser-options
      @callback
      @call-callback
      @options
      @opts
    }

  parse-selector ->
    @parsed ?= {}
    @time 'parse-selector'
    @parsed.selector = @query-engine.parse @selector

  set-test-ext ->
    @test-ext = if exts.length is 0 or exts.length is 1 and exts.0 is '.'
      -> true
    else
      (.match //\.(?:#{ exts.join '|' })$//)

  exclude-fun ->
    (file, basePath, upPath) ~>
      filePath = path.relative basePath, path.join upPath, file
      @exclude.every (excludePattern) ->
        !minimatch filePath, excludePattern, @options.minimatchOptions

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

  handle-recursive ->
    @targets = (if options.recursive then ['.'] else ['-']) unless @targets.length

  handle-selector ->
    unless @selector?
      error 'Error: No selector specified.'
      help-string = get-help!
      callback help-string
      exit 2, help-string
      return

  handle-replace-file ->
    return unless @options.replace-file
    try
      @replacement = @fs.read-file-sync that, 'utf8' .replace /([\s\S]*)\n$/ '$1'
    catch
      @error "Error: No such file '#{@options.replace-file}'."
      @exit 2
      return

  is-replace ->
    @options.replace? or @options.replace-func

  handle-replace ->
    if is-replace?
      @replacement = that
    else
      @handle-replace-file!

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

  handle-file ->
    if @options.file?
      @selector-from-file!
    else
      @selector-from-pos!

  handle-help ->
    return unless @options.help
    help-string = @get-help!
    @callback help-string
    @exit 0, help-string
    return


  get-help ->
    help generate-help, generate-help-for-option, @positional, {version}

  extract-opts ->
    @exts = @options.extensions
    @exclude = @options.exclude
    @call-callback = not @options.quiet and not @options.json and not @options.to and not @options.in-place

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

  handle-jsx ->
    return unless @options.jsx
    @options.extensions.push('jsx')
    if @options.parser.0 == 'acorn'
      require 'acorn-jsx'
      @options.parser.1.plugins = {jsx: true}

  handle-version ->
    return unless @options.version
    version-string = "grasp v#version"
    @callback version-string
    @exit 0, version-string
    return

  start-debug ->
    @time 'everything'
    @log 'options:'
    @log options

  end-debug ->
    @time-end 'parse-selector'
    @log 'parsed-selector:'
    @log JSON.stringify parsed-selector, null, 2