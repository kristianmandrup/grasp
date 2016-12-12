{grasp} = require '../_helpers'
{strict-equal: equal} = require 'assert'

suite 'runner' ->
  suite 'class Runner' ->
    suite 'create instance' ->
      test 'basic' ->

      # ...

    suite 'parse-args' ->
      test '@options' ->
      test '@positional' ->
      test '@debug' ->

    suite 'validate-args' ->

    suite 'handle-jsx' ->

    suite 'handle-version' ->

    suite 'start-debug' ->

    suite 'end-debug' ->

    suite 'extract-opts' ->
      test '@exts' ->
      test '@exclude' ->
      test '@call-callback' ->

    suite 'search-targets' ->

    suite 'do-search' ->
      test '@target-paths' ->

    suite 'prepare-search' ->
      test '@search' ->

    suite 'parse-selector' ->
      test '@parsed' ->

      test '@parsed.selector' ->

    suite 'set-test-ext' ->
      test '@test-ext' ->

    suite 'exclude-fun' ->

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

    suite 'handle-recursive' ->
      test '@targets' ->

    suite 'handle-selector' ->

    suite 'handle-replace-file' ->

    suite 'is-replace' ->

    suite 'handle-replace' ->
      test 'do replace' ->

      test 'no replace' ->

    suite 'selector-from-file' ->
      test '@selector' ->

    suite 'selector-from-pos' ->
      test '@selector' ->
      test '@targets' ->

    suite 'handle-file' ->
      test 'w file' ->

      test 'no file' ->

    suite 'handle-help' ->
      test 'help' ->

      test 'no help' ->

    suite 'get-help' ->

    suite 'search-input' ->
      test '@results-format' ->

    suite 'run' ->

