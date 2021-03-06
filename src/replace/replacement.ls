{ replacer } = require './replacer'

filter-regex = //
               \s+\|\s+
               ([-a-zA-Z]+)
               ((?:\s+(?:'(?:\\'|[^'])*'|"(?:\\"|[^"])*"|[^\|\s]+))*)
               //

has-filter = (txt) ->
  /^\s*\|\s+/.test txt

# actions Object could potentially be used here
parse-filters = (filter-str, actions) ->
  filter-str = filter-str.trim!

  if has-filter? filter-str
    [, ...filters] = " #{ filter-str }".split filter-regex # prepend space so regex works
  else
    [selector, ...filters] = filter-str.split filter-regex

extract =  (replacement, actions) ->
  parse-filters replacement, actions

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
    replace-fun = replacer input, node, query-engine, actions

    replacement-prime
    .replace /{{}}/g, -> get-raw input, node # func b/c don't want to call get-raw unless we need to
    .replace /{{((?:[^}]|}[^}])+)}}/g, replace-fun

is-fun = (fun) ->
  typeof! fun is 'Function'

get-replacement-func = (replacement, input, query-engine, actions) ->
  create-fun = if is-fun? replacement then use-replacement-func else create-replacement-func
  create-fun replacement, input, query-engine, actions

module.export =
  get-replacement-func
  extract