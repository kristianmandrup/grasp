valid-filter-name = (name) ->
  name in <[ prepend before after prepend append wrap nth nth-last
                                            slice each replace substring substr str-slice ]>

valid-filter = (args, name) ->
  args.length and valid-filter-name name

valid-replace = (args, name) ->
  name in <[ replace ]> and args.length < 2

validate = (args, name) ->
    if not valid-filter args, name
      throw new Error "No arguments supplied for '#name' filter"
    else if invalid-replace
      throw new Error "Must supply at least two arguments for '#name' filter"

module.exports = validate