{ lines, unlines, filter, fold, capitalize, camelize, dasherize} = require 'prelude-ls'

Filter = require './clazz'

filter = (name, args, {raw, results, text-operations}) ->
  if not args.length and name in <[ prepend before after prepend append wrap nth nth-last
                                            slice each replace substring substr str-slice ]>
    throw new Error "No arguments supplied for '#filter-name' filter"
  else if name in <[ replace ]> and args.length < 2
    throw new Error "Must supply at least two arguments for '#filter-name' filter"

  join = null
  op-filter = new Filter({name, args, join, raw, results, text-operations})
  try
    return op-filter[name]
  catch
    args-str = if args then args else ''
    throw new Error "Invalid filter: #name#{args-str}"


