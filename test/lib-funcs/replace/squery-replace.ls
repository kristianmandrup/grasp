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


    test 'full squery' ->
      equal (grasp.replace 'grasp-squery', '#x', 'y', input), replaced

    test 'with replace function' ->
      equal (grasp.replace 'squery' 'func', (get-raw, node, query) ->
        x = get-raw (query '.params' .0)
        """
        function #{ node.id.name }AddZ(#{ query '.params' .map get-raw .concat ['z'] .join ', ' }) {
          return #x * #x + z;
        }
        """
      , input), """
                  function squareAddZ(x, z) {
                    return x * x + z;
                  }
                  """

    test 'with append' ->
      const find = """
        class[key=#Hello] body[type=#ClassBody]
      """

      const replace = """
        {{ .body | append:fn }}
      """

      const code = '''class Hello {
      }'''

      const replacer = grasp.replace 'squery', {find, replace }
      const result = replacer.replace(code, [{
        action: 'append',
        name: 'fn',
        node: {
          type: 'Raw',
          raw: 'hello () { }'
        }
      }])
      const expected = """class Hello {
        hello () { }
      }"""

      equal (result, expected)

