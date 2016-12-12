{grasp} = require '../_helpers'
{strict-equal: equal} = require 'assert'

create-search = {console, call-callback, callback, options, parsed, parser-options, opts}
  # TODO: fix arguments
  new Search console, opts

create-opts-search = (opts) ->
  create-search {opts}

create-default-search = ->
  create-opts-search opts: {}

suite 'search' ->
  suite 'class Search' ->
    suite 'create instance' ->
      test 'basic' ->
        create-default-search!
      # ...

    suite 'set-count' ->
      test 'has no max-count' ->

      test 'has max-count' ->

    suite 'set-results' ->
      test '@sorted' ->

      test '@sliced' ->

    suite 'replace-pairs' ->
      test 'options: none' ->
        s = create-opts-search opts: {}
        eq s.replace-pairs, false

      test 'options: to' ->
        s = create-opts-search opts: {to: 'x'}
        eq s.replace-pairs, true

      test 'options: in-place' ->
        s = create-opts-search opts: {in-place: 'x'}
        eq s.replace-pairs, true

    suite 'handle-replacement' ->
      test 'has no replacement' ->
        # returns void

      test 'has replacement' ->

    suite 'handle-display-filename' ->
      test 'has no display-filename' ->
        # returns void

      test 'has display-filename' ->

    suite 'count-data' ->

    suite 'handle-count' ->
      test 'has no count' ->
        # returns void

      test 'has count' ->

    suite 'is-matching' ->

    suite 'handle-file-matching' ->
      test 'has no count files-without-match or files-with-matches' ->
        # returns void

      test 'has count' ->

    suite 'handle-pairs' ->
      test 'has no display-filename' ->
        # returns void

      test 'has display-filename' ->

    suite 'handle-lists' ->

    suite 'handle-json-data' ->

    suite 'handle-input-data' ->

    suite 'handle-data' ->

    suite 'parse-input' ->

    suite 'query' ->

    suite 'search(@name, @input)' ->








