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

module.exports =
  exit
  get-args
  set-replace