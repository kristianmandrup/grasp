require! {
  path
  acorn
  'grasp-squery': squery
  'grasp-equery': equery
  async
  minimatch
}
{min, sort-with, lines, chars, split, join,  map, Obj} = require 'prelude-ls'
{format-result, format-name, format-count}:format = require './format'
{replace} = require './replace'
{parse: parse-options,  generate-help, generate-help-for-option} = require './options'
help = require './help'

search = require './search'

{ search-target, get-query-engine, get-display-filename } = require './utils'


results-sort-func = (a, b) ->
  a-start = a.loc.start
  b-start = b.loc.start
  line-diff = a-start.line - b-start.line
  if line-diff is 0 then a-start.column - b-start.column else line-diff

process-results = ->
  if results-data.length
    if results-format is 'pairs'
      Obj.pairs-to-obj results-data
    else if results-format is 'lists'
      if targets-len is 1 then results-data.0 else results-data
    else
      results-data
  else
    []

get-to-map = (input-paths) ->
  if options.in-place
    Obj.lists-to-obj input-paths, input-paths
  else if typeof! options.to is 'Object'
    options.to
  else # typeof! options.to is 'String'
    mapping = {}
    for input-path in input-paths
      mapping[input-path] = options.to.replace /%/, path.basename input-path, (path.extname input-path)
    mapping

end = (input-paths) ->
  exit-code = if results-data.length then 0 else 1
  processed-results = process-results!
  if replacement and options.to or options.in-place
    to-map = get-to-map input-paths
    for input-path, contents of processed-results
      target-path = to-map[input-path]
      if target-path is '-'
        callback contents
      else
        fs.write-file-sync target-path, contents if target-path
  else if options.json
    json-string = JSON.stringify processed-results
    callback json-string
  console.time-end 'everything' if debug
  exit exit-code, (if options.json then json-string else processed-results)



