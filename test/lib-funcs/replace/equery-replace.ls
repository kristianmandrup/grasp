{grasp} = require '../../_helpers'
{strict-equal: equal} = require 'assert'

suite 'lib functions' ->
  input = '''
          function square(x) {
            return x * x;
          }
          '''

  suite 'replace' ->
    replaced = '''
               function square(y) {
                 return y * y;
               }
               '''

    test 'equery' ->
      equal (grasp.replace 'equery' 'x', 'y', input), replaced

    test 'with replace function (equery)' ->
      equal (grasp.replace 'equery', 'return $x * $x;', (get-raw, node, query, named) ->
        X = (get-raw named.x).to-upper-case!
        "return #X * #X;"
      , input), """
                  function square(x) {
                    return X * X;
                  }
                  """
