Runner = require './runner'

get-query-engine = -> {squery: 'grasp-squery', equery: 'grasp-equery'}[it] or it

get-args = (engine, selector) ->
  {_: [selector], engine: get-query-engine engine}

is-fun = (fun) ->
  typeof! replacement is 'Function'

set-replace = (args, replacement) ->
  if is-fun? replacement
    args.replace-func = replacement
  else
    args.replace = replacement

exit = (, results) ->
  results.0

run <<<
  VERSION: version
  search: (engine, selector, input, opts) -->
    if typeof selector is 'object'
      { selector, code, opts } = selector
      selector ?= selector.find or selector.query or selector.select
      input ?= selector.code

    args = get-args engine, selector
    new Runner({ input, exit, opts, actions, data: true }).run!

  # actions are passed via opts object
  replace: (engine, selector, replacement, input, opts) -->
    actions = null
    if typeof selector is 'object'
      { selector, replacement, input, actions, opts } = selector
      selector ?= selector.find or selector.query or selector.select
      input ?= selector.code
      replacement ?= selector.replace

    args = get-args engine, selector
    set-replace args, replacement
    new Runner({ args, input, exit, actions, opts }).run!

module.exports = run
