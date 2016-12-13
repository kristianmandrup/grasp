{ lines, unlines, filter, fold, capitalize, camelize, dasherize} = require 'prelude-ls'

Filter = require './clazz'
validate = require './validate'

filter = (name, args, {raw, results, text-operations, actions}) ->
  validate name, args
  op-filter = new Filter({name, args, raw, results, text-operations, actions})
  try
    operation = name
    op-arg = null
    # append:fn will look up entries append:fn and fn in actions Objects
    if /:/.test name
      parts = name.split ':'
      operation = parts[0]
      op-name = parts[1]
      op-arg = actions[name] or actions[op-name]

    op-method = op-filter[operation]
    op-method(op-arg)
  catch
    args-str = if args then args else ''
    throw new Error "Invalid filter: #name#{args-str}"


