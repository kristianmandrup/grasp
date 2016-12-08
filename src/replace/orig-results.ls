{ has-filter } = require './utils'

class QueryMaker
  (query-engine, node) ->
    @query-engine = query-engine
    @node = node

  query(selector, backup-selector) ->
    try
      @query-engine.query selector, node
    catch
      @query-engine.query backup-selector, node

make-query = (query-engine, node) ->
  new QueryMaker query-engine, node

query-results = (query-engine, node, selector) ->
  if node._named?[selector]
    ->
      [].concat that
  else
    (replacement-arg) ->
      querier = make-query query-engine, node
      querier.query selector, replacement-arg

get-orig-results = (query-engine, node, selector, filter-arg) ->
  if has-filter filter-arg then
    ->
      [node]
  else
    query-results query-engine, node, selector
