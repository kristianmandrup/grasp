// Generated by LiveScript 1.5.0
(function(){
  var Logger, Handlers, Setters, Search;
  Logger = require('../logger');
  Handlers = require('./handlers');
  Setters = require('./setters');
  module.exports = Search = (function(){
    Search.displayName = 'Search';
    var prototype = Search.prototype, constructor = Search;
    importAll$(prototype, arguments[0]);
    importAll$(prototype, arguments[1]);
    importAll$(prototype, arguments[2]);
    function Search(arg$){
      var ref$;
      this.console = arg$.console, this.callCallback = arg$.callCallback, this.callback = arg$.callback, this.options = arg$.options, this.parsed = arg$.parsed, this.parserOptions = arg$.parserOptions, this.results = (ref$ = arg$.results) != null
        ? ref$
        : [], this.actions = arg$.actions, this.opts = arg$.opts;
      this.searchResults = {};
      this.searchResults.data = [];
      this.searchResults.format = 'default';
      this.out = function(it){
        this.searchResults.data.push(it);
        if (this.callCallback) {
          this.callback(it);
        }
      };
    }
    replacePairs(function(){
      return this.options.to || this.options.inPlace;
    });
    countData(function(){
      return this.out(this.options.json || this.data
        ? this.count
        : formatCount(this.color, this.count));
    });
    isMatching(function(){
      return this.options.filesWithMatches && this.count || this.options.filesWithoutMatch && !this.count;
    });
    parseInput(function(){
      var e;
      this.cleanInput = this.input.replace(/^#!.*\n/, '');
      try {
        this.time("parse-input:" + name);
        this.parsed.input = parser.parse(this.cleanInput, parserOptions);
        this.timeEnd("parse-input:" + name);
        if (this.options.printAst) {
          return this.log(JSON.stringify(this.parsed.input, null, 2));
        }
      } catch (e$) {
        e = e$;
        throw new Error("Error: Could not parse JavaScript from '" + name + "'. " + e.message);
      }
    });
    query(function(){
      this.time("query:" + name);
      this.results = this.queryEngine.queryParsed(this.parsed.selector, this.parsed.input);
      return this.timeEnd("query:" + name);
    });
    search(Search.name, Search.input)(function(){
      this.time("search-total:" + name);
      this.parseInput();
      this.query();
      this.setCount();
      this.setResults();
      this.handleReplacement() || this.handleCount() || this.handleFileMatching() || handleData();
      this.timeEnd("search-total:" + name);
    });
    return Search;
  }(Logger, Handlers, Setters));
  function importAll$(obj, src){
    for (var key in src) obj[key] = src[key];
    return obj;
  }
}).call(this);
