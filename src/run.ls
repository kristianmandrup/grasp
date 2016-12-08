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
  search: (engine, selector, input) -->
    args = get-args engine, selector
    new Runner({ input, exit, data: true }).run!

  replace: (engine, selector, replacement, input) -->
    args = get-args engine, selector
    set-replace args, replacement
    new Runner({ args, input, exit }).run!

module.exports = run
