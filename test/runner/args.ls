{grasp} = require '../_helpers'
{strict-equal: equal} = require 'assert'

suite 'runner: args' ->
  suite 'class Runner' ->
    suite 'parse-args' ->
      test '@options' ->
      test '@positional' ->
      test '@debug' ->

    suite 'validate-args' ->
      test 'has args' ->
      test 'no args' ->
