levn = require 'levn'

make-query = (query-engine, node) ->
  (selector, backup-selector) ->
    try
      query-engine.query selector, node
    catch
      query-engine.query backup-selector, node

filter-regex = //
               \s+\|\s+
               ([-a-zA-Z]+)
               ((?:\s+(?:'(?:\\'|[^'])*'|"(?:\\"|[^"])*"|[^\|\s]+))*)
               //

get-args = (filters) ->
  args-str = filters.shift!.trim!
  args-str += filters.shift! # extra
  levn.parse 'Array', args-str

has-filter = (txt) ->
  /^\s*\|\s+/.test txt

parse-filters = (filter-str) ->
  if has-filter filter-arg
    [, ...filters] = " #{ filter-arg.trim! }".split filter-regex # prepend space so regex works
  else
    [selector, ...filters] = filter-arg.trim!.split filter-regex

get-filters =  (filter-arg) ->
  filter-arg if Array.isArray filter-arg
  parse-filters filter-arg

query-results = (node, selector) ->
  if node._named?[selector]
    ->
      [].concat that
  else
    (replacement-arg) ->
      query = make-query query-engine, node
      query selector, replacement-arg

get-orig-results = (node, selector, filter-arg) ->
  if has-filter filter-arg then
    ->
      [node]
  else
    query-results node selector

get-raw = (input, node) ->
  raw = if node.raw
    that
  else if node.start?
    input.slice node.start, node.end
  else if node.key? and node.value? # property
    input.slice node.key.start, node.value.end
  else
    ''
  node.raw = raw
  "#{ node.raw-prepend or '' }#raw#{ node.raw-append or '' }"

module.exports = {
  get-raw
  get-orig-results
  parse-filters
}