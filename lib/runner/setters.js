// Generated by LiveScript 1.5.0
(function(){
  module.exports = [
    setAll(function(){
      this.setEngine();
      this.setParser();
      this.setContext();
      this.setOutputFormat();
      this.setTestExt();
      return this.setTestExclude();
    }), setEngine(function(){
      return this.queryEngine = getQueryEngine(this.options);
    }), setTestExt(function(){
      var this$ = this;
      return this.testExt = exts.length === 0 || exts.length === 1 && exts[0] === '.'
        ? function(){
          return true;
        }
        : function(it){
          return it.match(RegExp('\\.(?:' + exts.join('|') + ')$'));
        };
    }), setTestExclude(function(){
      return this.testExclude = !this.exclude || this.exclude.length === 0
        ? function(){
          return true;
        }
        : this.excludeFun();
    }), setOutputFormat(function(){
      var ref$;
      this.color = Obj.map(function(it){
        if (this.options.color) {
          return it;
        } else {
          return function(it){
            return it + "";
          };
        }
      }, {
        green: (ref$ = this.textFormat).green,
        cyan: ref$.cyan,
        magenta: ref$.magenta,
        red: ref$.red
      });
      this.bold = this.options.bold
        ? this.textFormat.bold
        : function(it){
          return it + "";
        };
      return this.textFormatFuncs = {
        color: color,
        bold: bold
      };
    }), setParser(function(){
      var ref$, parser, parserOptions;
      ref$ = (function(){
        switch (options.parser[0]) {
        case 'acorn':
          return [acorn, options.parser[1]];
        default:
          return [require(options.parser[0]), options.parser[1]];
        }
      }()), parser = ref$[0], parserOptions = ref$[1];
      this.parser = parser;
      return this.parserOptions = parserOptions;
    }), setContext(function(){
      var ref$, ref1$;
      (ref$ = this.options).context == null && (ref$.context = (ref$ = this.options.NUM) != null ? ref$ : 0);
      (ref$ = this.options).beforeContext == null && (ref$.beforeContext = this.options.context);
      return (ref1$ = (ref$ = this.options).afterContext) != null
        ? ref1$
        : ref$.afterContext = this.options.context;
    })
  ];
}).call(this);