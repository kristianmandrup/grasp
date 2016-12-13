version = require('../package.json').version

{ search-target, get-query-engine, get-display-filename } = require './utils'

Logger = require '../logger'
Search = require '../search'
Handlers = require './handlers'
Setters = require './setters'
Debug = require './debug'
Args = require './args'
Selector = require './selector'
Search = require './search'

_console = console
_fs = require 'fs'
_tf = require 'cli-color'

class Runner implements Logger, Handlers, Setters, Debug, Args, Selector, Search
  ({
  @opts
  @actions
  @args
  @error = -> throw new Error it
  @callback = ->
  @exit = ->
  @data = false
  @stdin
  @fs = _fs
  @text-format = _tf
  @input
  @console = _console
  } = {}) ->
    @validate-args!
    @parse-args!
    @extract-opts!

    @start-debug!

    @handle-all!
    @set-all!

    @prepare-search!
    @parse-selector!
    @end-debug!

  run ->
    @do-search!

  exclude-fun ->
    (file, basePath, upPath) ~>
      filePath = path.relative basePath, path.join upPath, file
      @exclude.every (excludePattern) ->
        !minimatch filePath, excludePattern, @options.minimatchOptions

  get-help ->
    @help generate-help, generate-help-for-option, @positional, {version}
