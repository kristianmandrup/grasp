{ replacer } = require './replacer'

use-replacement-func = (replacement, input, query-engine) ->
  (node) ->
    replacement do
      -> get-raw input, it
      node
      -> query-engine.query it, node
      node._named

create-replacement-func = (replacement, input, query-engine, actions) ->
  replacement-prime = replacement.replace /\\n/g, '\n'
  (node) ->
    replacement-prime
    .replace /{{}}/g, -> get-raw input, node # func b/c don't want to call get-raw unless we need to
    .replace /{{((?:[^}]|}[^}])+)}}/g, replacer input, node, query-engine, actions

is-fun = (fun) ->
  typeof! fun is 'Function'

get-replacement-func = (replacement, input, query-engine, actions) ->
  create-fun = if is-fun? replacement then use-replacement-func else create-replacement-func
  create-fun replacement, input, query-engine, actions

module.export = { get-replacement-func }