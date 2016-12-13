levn = require 'levn'

get-args = (filters) ->
  args-str = filters.shift!.trim!
  args-str += filters.shift! # extra
  levn.parse 'Array', args-str

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

