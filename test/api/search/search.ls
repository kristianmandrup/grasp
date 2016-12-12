{grasp} = require '../../_helpers'
{strict-equal: equal} = require 'assert'

suite 'API functions' ->
  input = '''
          function square(x) {
            return x * x;
          }
          '''
  test 'version' ->
    equal grasp.VERSION, (require '../package.json' .version)

  suite 'search' ->
    test 'basic' ->
      equal 3, (grasp.search 'squery', '#x', input .length)
      equal 2, (grasp.search 'squery', 'bi #x', input .length)

    test 'curried' ->
      equal 3, (grasp.search 'squery', '#x')(input).length
      equal 3, (grasp.search 'squery')('#x')(input).length

    test 'equery' ->
      equal 3, (grasp.search 'equery', 'x', input .length)

