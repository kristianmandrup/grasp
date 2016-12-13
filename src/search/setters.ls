module.exports =
  set-count ->
    @count = if @options.max-count? then min that, @results.length else @results.length

  set-results ->
    @search-results.sorted = sort-with @search-results.sort-func, @results
    @search-results.sliced = @search-results.sorted[til count]
