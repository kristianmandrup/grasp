// Generated by LiveScript 1.5.0
(function(){
  var getQueryEngine, getArgs, isFun, setReplace, exit, toString$ = {}.toString;
  getQueryEngine = function(it){
    return {
      squery: 'grasp-squery',
      equery: 'grasp-equery'
    }[it] || it;
  };
  getArgs = function(engine, selector){
    return {
      _: [selector],
      engine: getQueryEngine(engine)
    };
  };
  isFun = function(fun){
    return toString$.call(replacement).slice(8, -1) === 'Function';
  };
  setReplace = function(args, replacement){
    if (typeof isFun == 'function' && isFun(replacement)) {
      return args.replaceFunc = replacement;
    } else {
      return args.replace = replacement;
    }
  };
  exit = function(arg$, results){
    return results[0];
  };
  module.exports = [exit, getArgs, setReplace];
}).call(this);
