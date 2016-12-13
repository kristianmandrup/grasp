# grasp

JavaScript structural search, replace, and refactor.

[Demo](http://graspjs.com#demo), [documentation](http://graspjs.com/docs/), and more: [graspjs.com](http://graspjs.com).

Install: `npm install -g grasp`.

`grasp --help` for help.

## TODO

Complete test suite with tests for full (~95%) coverage and make all tests pass!

## Development

Watch `/src` compile and output to `/lib` via

`npm run dev`

which runs livescript compiler in watch mode:

`lsc -wco lib src`

### Compile src

`npm run build-src`

## Testing

`npm t` to run tests in `/tests` folder which runs `test` (mocha) task in `Makefile`:

`$(MOCHA) --reporter dot --ui tdd --compilers ls:$(LS)`

It currently uses the [TDD interface](https://mochajs.org/#tdd)

When debugging or refactoring, you can limit which tests to run, see [CLI usage](https://mochajs.org/#usage)

## Test Coverage

`npm run cover` (see `coverage` entry in `Makefile`)

## API

### Replace

```ls
const engine = 'squery'

const actions =
  type: 'Raw'
  raw: 'hello'

const code = 'class Hello {}'
const select = 'class[key=#Hello] body[type=#ClassBody]'
const replace = '{{ .body | append:fn }}'

# (engine, selector, replacement, input, opts)
grasp.replace engine, { select, replace, code, actions}
```

### Search

```ls
const selector = 'class[key=#Hello] body[type=#ClassBody]'
const code = 'class Hello {}'

# (engine, selector, input, opts)
grasp.search 'squery', { selector, code}
```

## API Architecture

`run.ls` exports a run object with `search` and `replace` that is also exported in `index.ls`

```ls
run <<<
  VERSION: version
  search: (engine, selector, input, opts) -->
    if typeof selector is 'object'
      { selector, code, opts } = selector
      selector ?= selector.find or selector.query or selector.select
      input ?= selector.code

    args = get-args engine, selector
    new Runner({ input, exit, opts, actions, data: true }).run!

  # actions are passed via opts object
  replace: (engine, selector, replacement, input, opts) -->
    actions = null
    if typeof selector is 'object'
      { selector, replacement, input, actions, opts } = selector
      selector ?= selector.find or selector.query or selector.select
      input ?= selector.code
      replacement ?= selector.replace

    args = get-args engine, selector
    set-replace args, replacement
    new Runner({ args, input, exit, opts }).run!
```

The `opts` object can be used to send additional argument and is currently used to pass filter `actions` used by replacement.

You can call the core APIs either via numbered:

`grasp.replace(engine, selector, replacement, input, opts)`

or named arguments:

`grasp.replace('squery', {select, replace, input, actions})`

## Replacements

`search/handlers.ls` handles replace via `handle-replacement`. Here, `replace` is a function that returns the replaced code.

```ls
  handle-replacement ->
    return unless @replacement?
    try
      # added actions :)
      replaced = replace @replacement, @clean-input, @search-results.sliced, @query-engine, @actions
```

The `replace` function is exported from `replace/index.ls` and uses:
-  a `query-engine` (such as equery or squery)
-  a `replacement` string (such as `{{.body | append:fn }})` or `{{ }} + 1`
- optional `actions` object used by replacement filters (see below).
- ...

```ls
replace = (replacement, input, nodes, query-engine, actions) ->
  replace-nodes = create-replace-nodes replacement, input, nodes, query-engine, actions
  replace-nodes.iterate!
  unlines replace-nodes.input-lines
```

In `ReplaceNodes` class we create and set the `@replace-node` function in the constructor via `get-replacement-func` from `replace/replacement.ls`

```ls
    @replace-node = get-replacement-func @replacement, @input, @query-engine, actions
```

The `iterate` method iterates each node matched by the query and performs a replace via `@process`.

```ls
  iterate ->
    for node in @nodes
      continue if node.start < prev-node.end
      @process node
```


The `get-replacement-func` creates the replacement function used to replace the code for each node matched.
If the `replacement` argument is a function we use it as is, otherwise we create it via `create-replacement-func`.

```ls
get-replacement-func = (replacement, input, query-engine, actions) ->
  create-fun = if is-fun? replacement then use-replacement-func else create-replacement-func
  create-fun replacement, input, query-engine, actions
```

`create-replacement-func` takes the replacement argument, the input, query engine to use and an actions (object) and returns
a replacement function that, given a node returns the raw code to replace it with.

```ls
create-replacement-func = (replacement, input, query-engine, actions) ->
  replacement-prime = replacement.replace /\\n/g, '\n'
  (node) ->
    replace-fun = replacer input, node, query-engine, actions

    replacement-prime
    .replace /{{}}/g, -> get-raw input, node # func b/c don't want to call get-raw unless we need to
    .replace /{{((?:[^}]|}[^}])+)}}/g, replace-fun
```

We see that the last `.replace` uses `replace-fun` which is generated via `replacer` in `replace/replacer.ls`

```ls
replacer = (input, node, query-engine, actions) ->
  # optional filter and actions argument
  (, replacement-arg) ->
    # ...
```

The `(, replacement-arg) ->` function is the [String.replace](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/replace#Specifying_a_function_as_a_parameter)
handler function (where the first argument `match` is ignored (ie. it only considers/uses the first `p1` match).

The replace function uses `process-orig` which calls `process-filters` to process any filters (ie. of the form `| filter`).

```ls
process-filters = ({results, text-operations, filters, actions, raw}) ->
  while filters.length
    filter-name = filters.shift!
    args = get-args filters
    filter filter-name, args, {raw, results, text-operations, actions}
```

If there are filters, it extracts the name of the filter and any filter arguments and filters via
the `filter` function in `replace/filter/index/ls`.

`filter` first validates the filter name and argument. If valid it creates a `Filter` instance `op-filter` (operation filter) used to handle filtering.
The filter `name` is used to determine the filter operation.

```ls
  validate name, args
  op-filter = new Filter({name, args, raw, results, text-operations, actions})
```

If the name contains a `:`, the operation can be passed an action (operation) argument by lookup in the `actions` object.
Currently only `append` and `prepend` supports a `node` argument

```ls
  operation = name
  op-arg = null

  # append:fn will look up entries append:fn and fn in actions Objects
  if /:/.test name
    parts = name.split ':'
    operation = parts[0]
    op-name = parts[1]
    op-arg = actions[name] or actions[op-name]

  op-method = op-filter[operation]
  op-method(op-arg)
```

In `Filter` class the `append` method expects an optional node argument (from actions).

```ls
  append(node) ->
    append-node @results, node if node
    for arg in @args then append @results, arg
```

The `node` argument is used in `append-node` to append the `node` to `@results`.
If there are arguments `args`, these are then appended directly as `raw` nodes.

```ls
append = (results, arg) ->
  append-node results, type: 'Raw', raw: "#arg"

append-node = (results, node) ->
  results.push node
```

## License

[MIT license](https://github.com/gkz/grasp/blob/master/LICENSE).
