get-query-engine = -> {squery: 'grasp-squery', equery: 'grasp-equery'}[it] or it

run <<<
  VERSION: version
  search: (engine, selector, input) -->
    run do
      args: {_: [selector], engine: get-query-engine engine}
      input: input
      data: true
      exit: (, results) -> results
  replace: (engine, selector, replacement, input) -->
    args =
      _: [selector]
      engine: (get-query-engine engine)

    if typeof! replacement is 'Function'
      args.replace-func = replacement
    else
      args.replace = replacement

    run {args, input, exit: (, results) -> results.0}

module.exports = run
