{ get-filters, get-args, get-raw } = require './utils'
{ get-orig-results } = require './orig-results'
{ replacer } = require './replacer'
{ unlines, lines } = require 'prelude-ls'
{ ReplaceNode } = './replace-node'

# replace replacement, clean-input, sliced-results, query-engine
replace = (replacement, input, nodes, query-engine) ->
  replace-node = new ReplaceNode replacement, input, nodes, query-engine
  replace-node.iterate!
  unlines replace-node.input-lines

module.exports = { replace }
