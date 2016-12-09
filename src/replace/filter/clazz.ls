{ TextOps, ListOps } = require './ops'

wrap = (raw, args) ->
  [pre, post] = if args.length is 1 then [args.0, args.0] else args
  raw.prepend := "#pre#raw.prepend"
  raw.append += "#post"

module.exports = class Filter implements TextOperations, ListOps
  ({@name, @args, @raw, @results, @text-operations}) ->
    this.head = this.first.bind(this)

  join ->
    @join := if @args.length then "#{@args.0}" else ''
  before ->
    @raw.prepend := "#{@args.0}#raw.prepend"
  after ->
    @raw.append += "#{@args.0}"
  wrap ->
    wrap raw, args



  [join, raw, results, text-operations]