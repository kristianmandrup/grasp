{ get-replacement-func } = require './replacement'
{ lines } = require 'prelude-ls'

create-replace-nodes = (replacement, input, nodes, query-engine, actions) ->
  new ReplaceNodes replacement, input, nodes, query-engine, actions

class ReplaceNode
  ({@nodes, @input, @replacement, @query-engine, actions}) ->
    @input-lines = lines @input
    @col-offset = 0
    @line-offset = 0
    @last-line = null
    @prev-node = end: 0
    @replace-node = get-replacement-func @replacement, @input, @query-engine, actions

  iterate ->
    for node in @nodes
      continue if node.start < prev-node.end
      @process node

  # TODO: optimize, improve, simplify
  process(node) ->
    {start, end} = node.loc

    @start-line-num = start.line - 1 + @line-offset
    @end-line-num = end.line - 1 + @line-offset
    @number-of-lines = @end-line-num - @start-line-num + 1

    @col-offset := if @last-line is @start-line-num then @col-offset else 0

    @start-col = start.column + @col-offset
    @end-col = end.column + if @start-line-num is @end-line-num then @col-offset else 0

    # TODO: is this recursion correct?
    @replace-lines = lines @replace-node node

    @start-line = @input-lines[@start-line-num]
    @end-line = @input-lines[@end-line-num]

    @start-context = @start-line.slice 0, @start-col
    @end-context = @end-line.slice @end-col

    @replace-lines.0 = "#@start-context#{@replace-lines.0 ? ''}"
    @replace-last = @replace-lines[*-1]

    @end-len = @replace-last.length
    @replace-lines[*-1] = "#@replace-last#@end-context"
    @input-lines.splice @start-line-num, @number-of-lines, ...@replace-lines

    @line-offset += @replace-lines.length - @number-of-lines
    @col-offset += @end-len - @end-col
    @last-line := @end-line-num + @line-offset
    @prev-node := node

  module.exports =
    create-replace-nodes
    ReplaceNode