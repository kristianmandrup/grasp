module.exports =
  search-input ->
    return unless @input
    @search '(input)', @input
    @results-format = @search.results-format
    @end ['-'] # as if stdin for replacement

  search-targets ->
    cwd = process.cwd!
    async.each-series @targets, (search-target cwd, cwd), -> end @target-paths
    void

  do-search ->
    @target-paths = []
    @search-input! or @search-targets!

  prepare-search ->
    @search = new Search {
      @console
      @parsed
      @parser-options
      @callback
      @call-callback
      @options
      @actions
      @opts
    }
