{ get-filters, get-args, get-raw } = require './utils'
{ get-orig-results } = require './orig-results'
{ replacer } = require './replacer'
{ unlines, lines } = require 'prelude-ls'
{ create-replace-nodes } = './replace-nodes'

# replace replacement, clean-input, sliced-results, query-engine
replace = (replacement, input, nodes, query-engine, actions) ->
  replace-nodes = create-replace-nodes replacement, input, nodes, query-engine, actions
  replace-nodes.iterate!
  unlines replace-nodes.input-lines

module.exports = replace
