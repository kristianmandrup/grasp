search = (name, input) !->
  console.time "search-total:#name" if debug

  clean-input = input.replace /^#!.*\n/ ''
  try
    console.time "parse-input:#name" if debug
    parsed-input = parser.parse clean-input, parser-options
    console.time-end "parse-input:#name" if debug
    if options.print-ast
        console.log JSON.stringify parsed-input, null, 2
  catch
    throw new Error "Error: Could not parse JavaScript from '#name'. #{e.message}"

  console.time "query:#name" if debug
  results = query-engine.query-parsed parsed-selector, parsed-input
  console.time-end "query:#name" if debug

  results-len = results.length

  count = if options.max-count? then min that, results-len else results-len

  sorted-results = sort-with results-sort-func, results
  sliced-results = sorted-results[til count]

  if replacement?
    try
      replaced = replace replacement, clean-input, sliced-results, query-engine
      if options.to or options.in-place
        results-format := 'pairs'
        out [name, replaced]
      else
        out replaced
    catch
      console.error "#name: Error during replacement. #{e.message}."
  else if options.count
    if options.display-filename
      if options.json or data
        results-format := 'pairs'
        out [name, count]
      else
        out format-count color, count, name
    else
      out if options.json or data then count else format-count color, count
  else if options.files-without-match or options.files-with-matches
    if options.files-with-matches and count or options.files-without-match and not count
      out if options.json or data then name else format-name color, name
  else
    if options.json or data
      if options.display-filename
        results-format := 'pairs'
        out [name, sliced-results]
      else
        results-format := 'lists'
        out sliced-results
    else
      input-lines = lines clean-input
      input-lines-length = clean-input.length

      for result in sliced-results
        out format-result name, input-lines, input-lines-length, text-format-funcs, options, result

  console.time-end "search-total:#name" if debug

module.exports = search