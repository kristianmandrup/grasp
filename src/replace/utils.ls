levn = require 'levn'

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

# actions Object could potentially be used here
parse-filters = (filter-str, actions) ->
  filter-str = filter-str.trim!

  if has-filter? filter-str
    [, ...filters] = " #{ filter-str }".split filter-regex # prepend space so regex works
  else
    [selector, ...filters] = filter-str.split filter-regex

extract-replacement =  (replacement, actions) ->
  parse-filters replacement, actions

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
  prepend-str = node.raw-prepend or ''
  append-str = node.raw-append or ''
  "#{ prepend-str }#raw#{ append-str }"

module.exports =
  get-raw
  get-args
  extract-replacement
