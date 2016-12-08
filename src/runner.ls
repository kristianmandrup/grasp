version = require('../package.json').version

{ search-target, get-query-engine, get-display-filename } = require './utils'

class Runner
  ({
  args
  error = -> throw new Error it
  callback = ->
  exit = ->
  data = false
  stdin
  fs = require 'fs'
  text-format = require 'cli-color'
  input
  console = _console
  } = {}) ->
    @args = args
    @error = error
    @callback = callback
    @exit = exit
    @data = data
    @stdin = stdin
    @fs = fs
    @text-format = text-format
    @input = input
    @console = console

    @validate-args!
    @parse-args!

    @start-debug!
    @handle-version!
    @handle-help!
    @handle-jsx!

    @query-engine = get-query-engine options

    @set-parser!
    @set-context!
    @handle-file!
    @handle-recursive!
    @handle-replace!
    @handle-selector!

    options.display-filename = get-display-filename @options, @targets

    @set-output-format!
    @prepare-search!

    call-callback = not options.quiet and not options.json and not options.to and not options.in-place

    @parse-selector!
    @end-debug!

    # more...
    @set-test-ext!
    @set-test-exclude!
    @do-search!

  do-search ->
    @target-paths = []
    if @input
      @search '(input)', @input
      @results-format = @search.results-format
      end ['-'] # as if stdin for replacement
    else
      cwd = process.cwd!
      async.each-series @targets, (search-target cwd, cwd), -> end @target-paths
      void

  prepare-search ->
    @search = new Search

  parse-selector ->
    console.time 'parse-selector' if @debug
    @parsed-selector = @query-engine.parse @selector

  set-test-ext ->
    exts = @options.extensions
    @test-ext = if exts.length is 0 or exts.length is 1 and exts.0 is '.'
      -> true
    else
      (.match //\.(?:#{ exts.join '|' })$//)

  set-test-exclude ->
    exclude = options.exclude
    @test-exclude = if !exclude or exclude.length is 0
      -> true
    else
      (file, basePath, upPath) ->
        filePath = path.relative basePath, path.join upPath, file
        exclude.every (excludePattern) ->
          !minimatch filePath, excludePattern, options.minimatchOptions


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

  handle-replace ->
    if @options.replace? or @options.replace-func
      @replacement = that
    else if @options.replace-file
      try
        @replacement = @fs.read-file-sync that, 'utf8' .replace /([\s\S]*)\n$/ '$1'
      catch
        @error "Error: No such file '#{@options.replace-file}'."
        @exit 2
        return

  handle-file ->
    if @options.file?
      try
        @selector = @fs.read-file-sync that, 'utf8'
      catch
        @error "Error: No such file '#{@options.file}'."
        @exit 2
        return
      @targets = @positional
    else
      @selector = @positional.0
      @targets = @positional[1 to]

  handle-help ->
    if @options.help
      help-string = @get-help!
      @callback help-string
      @exit 0, help-string
      return


  get-help ->
    help generate-help, generate-help-for-option, @positional, {version}

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
    if @options.jsx
      @options.extensions.push('jsx')
      if @options.parser.0 == 'acorn'
        require 'acorn-jsx'
        @options.parser.1.plugins = {jsx: true}

  handle-version ->
    if @options.version
      version-string = "grasp v#version"
      @callback version-string
      @exit 0, version-string
      return

  start-debug ->
    return if not @debug?
    console.time 'everything'
    console.log 'options:'
    console.log options

  end-debug ->
    return if not @debug?
    console.time-end 'parse-selector'
    console.log 'parsed-selector:'
    console.log JSON.stringify parsed-selector, null, 2