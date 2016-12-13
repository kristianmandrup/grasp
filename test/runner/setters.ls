{grasp} = require '../_helpers'
{strict-equal: equal} = require 'assert'

suite 'runner' ->
  suite 'class Runner' ->
    suite 'set-test-exclude' ->
      test '@test-exclude' ->

    suite 'set-output-format' ->
      test '@color, @bold, @text-format-funcs' ->

    suite 'set-parser' ->
      test '@parser' ->

      test '@parser-options' ->

    suite 'set-context' ->
      test 'context' ->
      test 'before-context' ->
      test 'after-context' ->

    suite 'set-test-ext' ->
      test '@test-ext' ->
