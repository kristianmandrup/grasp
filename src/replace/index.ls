{ parse-filters, get-args, get-raw, get-orig-results } = require './utils'

replacer = (input, node, query-engine) ->
  (, replacement-arg, filter-arg) ->
    filter-arg = filter-arg || replacement-arg
    [selector, filters] = parse-filters filter-arg

    # TODO: clean up!
    query-results = get-orig-results node, selector, filter-arg
    query = query-results query-engine, node
    orig-results = query replacement-arg

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

{ get-replacement-func } = require './replacement'

replace = (replacement, input, nodes, query-engine) ->
  input-lines = lines input
  col-offset = 0
  line-offset = 0
  last-line = null
  prev-node = end: 0
  replace-node = get-replacement-func replacement, input, query-engine

  # TODO: gotta do better!!!
  for node in nodes
    continue if node.start < prev-node.end
    {start, end} = node.loc

    start-line-num = start.line - 1 + line-offset
    end-line-num = end.line - 1 + line-offset
    number-of-lines = end-line-num - start-line-num + 1

    col-offset := if last-line is start-line-num then col-offset else 0

    start-col = start.column + col-offset
    end-col = end.column + if start-line-num is end-line-num then col-offset else 0

    replace-lines = lines replace-node node
    start-line = input-lines[start-line-num]
    end-line = input-lines[end-line-num]

    start-context = start-line.slice 0, start-col
    end-context = end-line.slice end-col

    replace-lines.0 = "#start-context#{replace-lines.0 ? ''}"
    replace-last = replace-lines[*-1]

    end-len = replace-last.length
    replace-lines[*-1] = "#replace-last#end-context"
    input-lines.splice start-line-num, number-of-lines, ...replace-lines

    line-offset += replace-lines.length - number-of-lines
    col-offset += end-len - end-col
    last-line := end-line-num + line-offset
    prev-node := node

  unlines input-lines

module.exports = {replace}
