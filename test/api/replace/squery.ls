{grasp} = require '../../_helpers'
{strict-equal: equal} = require 'assert'

suite 'replace: squery basic' ->
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

    test 'basic' ->
      equal (grasp.replace 'squery', '#x', 'y', input), replaced

    test 'replace with nothing' ->
      replaced = '''
                 function square(x) {
                   return ;
                 }
                 '''
      equal (grasp.replace 'squery', 'func', '', input), ''
      equal (grasp.replace 'squery', 'return.arg', '', input), replaced

    test 'curried' ->
      equal (grasp.replace 'squery', '#x', 'y')(input), replaced
      equal (grasp.replace 'squery', '#x')('y')(input), replaced
      equal (grasp.replace 'squery')('#x')('y')(input), replaced
