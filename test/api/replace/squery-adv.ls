{grasp} = require '../../_helpers'
{strict-equal: equal} = require 'assert'

suite 'replace: squery' ->
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

  suite 'add method to class' ->
    # use ! to set subject used
    # http://www.graspjs.com/docs/squery/#subject

    # You could be more specific and do if!.test #x, which matches all if statements that have the identifier x in their test attribute.
    # You can have multiple subjects, and each subject you specify will be matched.
    # For example, if! #x! will match both if statements that have the identifier x as a descendant, and identifiers x who are descendants of if statements.
    const findBody = """
      class[key=#Hello] body[type=#ClassBody]
    """

    const expected = """class Hello {
      hello () { }
    }"""

    test 'with replace function' ->
      equal (grasp.replace 'squery' find, (get-raw, node, query) ->
        # TODO: append to body Array node instead!!

        """{
            hello () { }
        }"""
      , input), expected

    test 'with append action' ->

      const replace = """
        {{ .body | append:fn }}
      """

      const code = '''class Hello {
      }'''

      const actions = {
        'append:fn': [{
          type: 'Raw',
          raw: 'hello () { }'
        }]
      }

      const replacer = grasp.replace 'squery', {find, replace, actions }
      const result = replacer.replace(code)

      equal (result, expected)

