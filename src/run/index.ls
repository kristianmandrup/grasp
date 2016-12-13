Runner = require './runner'

{ exit, get-args, set-replace } = require './utils'

create-runner = ({ args, input, exit, actions, opts }) ->
  new Runner { args, input, exit, actions, opts } .run!

module.exports =
  VERSION: version
  search: (engine, selector, input, opts) -->
    if typeof selector is 'object'
      { selector, code, opts } = selector
      selector ?= selector.find or selector.query or selector.select
      input ?= selector.code

    args = get-args engine, selector
    create-runner { input, exit, opts, actions, data: true } .run!

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
    create-runner { args, input, exit, actions, opts } .run!

