{ get-filters } = require './utils'
{ get-orig-results } = require './orig-results'

process-filters = ({filters, raw}) ->
  while filters.length
    filter-name = filters.shift!
    args = get-args filters
    filter filter-name, args, {raw, results, text-operations}

make-output = (operations, output) ->
  if text-operations.length
    fold (|>), output, text-operations
  else
    output

get-output = ({raw, join}) ->
  output = "#raw.prepend#{ if join? then raw.results.join join else raw.results.0 }#raw.append"

process-orig = (orig-results, filters) ->
  # TODO: put in a record (Object)
  results = orig-results
  raw =
    prepend: ''
    append: ''

  join = null
  text-operations = []
  process-filters {results, filters, raw, text-operations}

  raw.results = [get-raw input, result for result in results]

  output = get-output {raw, join}
  make-output text-operations, output

replacer = (input, node, query-engine) ->
  (, replacement-arg, filter-arg) ->
    filter-arg = filter-arg || replacement-arg
    [selector, filters] = get-filters filter-arg

    # TODO: clean up!
    orig-results = get-orig-results(query-engine, node, selector, filter-arg) replacement-arg

    if orig-results.length
      process-orig orig-results, filters
    else
      ''

module.exports = { replacer }