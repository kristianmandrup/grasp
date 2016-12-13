{ lines, unlines, filter, fold, capitalize, camelize, dasherize} = require 'prelude-ls'

Filter = require './clazz'
validate = require './validate'

filter = (name, args, {raw, results, text-operations, actions}) ->
  validate name, args
  op-filter = new Filter({name, args, raw, results, text-operations, actions})
  try
    operation = name
    node = null

    # append:fn will look up entry append:fn in actions Objects to find node to append/prepend
    if /:/.test(name)
      parts = name.split ':'
      operation = parts[0]
      action = name
      node = actions[action]

    op-method = op-filter[operation]

    return op-method(node)
  catch
    args-str = if args then args else ''
    throw new Error "Invalid filter: #name#{args-str}"


