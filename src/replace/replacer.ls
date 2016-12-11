{ get-filters } = require './utils'
{ get-orig-results } = require './orig-results'

replacer = (input, node, query-engine) ->
  (, replacement-arg, filter-arg) ->
    filter-arg = filter-arg || replacement-arg
    [selector, filters] = get-filters filter-arg

    # TODO: clean up!
    orig-results = get-orig-results(query-engine, node, selector, filter-arg) replacement-arg

    if orig-results.length
      # TODO: put in a record (Object)
      results = orig-results
      raw =
        prepend: ''
        append: ''

      join = null
      text-operations = []

      while filters.length
        filter-name = filters.shift!
        args = get-args filters
        filter filter-name, args, {raw, results, text-operations}

      raw.results = [get-raw input, result for result in results]
      output = "#raw.prepend#{ if join? then raw-results.join join else raw.results.0 }#raw.append"

      if text-operations.length
        fold (|>), output, text-operations
      else
        output
    else
      ''

module.exports = { replacer }