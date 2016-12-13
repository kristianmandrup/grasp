{ extraxt } = require './replacement'
{ get-orig-results } = require './orig-results'
{ get-args, get-raw } = require '.utils'

process-filters = ({filters, actions, raw}) ->
  while filters.length
    filter-name = filters.shift!
    args = get-args filters
    filter filter-name, args, {raw, results, text-operations, actions}

make-output = (operations, output) ->
  if text-operations.length
    fold (|>), output, text-operations
  else
    output

get-output = ({raw, join}) ->
  output = "#raw.prepend#{ if join? then raw.results.join join else raw.results.0 }#raw.append"

process-orig = (orig-results, filters, actions) ->
  # TODO: put in a record (Object)
  results = orig-results
  raw =
    prepend: ''
    append: ''

  join = null
  text-operations = []
  process-filters {results, filters, raw, actions, text-operations}

  raw.results = [get-raw input, result for result in results]

  output = get-output {raw, join}
  make-output text-operations, output

replacer = (input, node, query-engine, actions) ->
  # optional filter and actions argument
  (, replacement-arg) ->
    [selector, filters] = extract replacement-arg, actions

    # TODO: clean up!
    orig-results = get-orig-results(query-engine, node, selector, filter-arg) replacement-arg

    if orig-results.length
      process-orig orig-results, filters, actions
    else
      ''

module.exports = { replacer }