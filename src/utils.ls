fs = require 'fs'

search-target = (base-path, up-path) ->
  (target, done) !->
    try
      if target is '-'
        throw new Error 'Error: stdin not defined.' unless stdin
        target-paths.push '-'
        output = ''
        stdin.set-encoding 'utf-8'
        stdin.on 'data' (output +=)
        stdin.on 'end' ->
          try
            search '(standard input)', output
          catch
            console.error e.message
          done!
        stdin.resume!
      else
        target-path = path.resolve up-path, target
        stat = fs.lstat-sync target-path
        if stat.is-directory! and options.recursive
          async.each-series (fs.readdir-sync target-path), (search-target base-path, target-path), ->
            async.setImmediate ->
              done!
        else if stat.is-file! and test-ext target and test-exclude target, basePath, upPath
          file-contents = fs.read-file-sync target-path, 'utf8'
          display-path = path.relative base-path, target-path
          target-paths.push display-path
          search display-path, file-contents
          done!
        else
          done!
    catch
      console.error e.message
      done!

get-query-engine = (options) ->
  if options.engine?
      require options.engine
    else if options.squery
      squery
    else if options.equery
      equery
    else
      squery

get-display-filename = (options, targets) ->
  if options.filename?
    options.display-filename = that
  else if targets.length > 1
    options.display-filename = true
  else
    try
      is-dir = if targets.0 is '-' then false else fs.lstat-sync targets.0 .is-directory!
      if is-dir and not options.recursive
        console.warn "'#{targets.0}' is a directory. Use '-r, --recursive' to recursively search directories."
      options.display-filename = is-dir
    catch
      error "Error: No such file or directory '#{targets.0}'."
      exit 2
      return

module.exports = { search-target, get-query-engine, get-display-filename }