module.exports =
  handler-all ->
    @handle-version!
    @handle-help!
    @handle-jsx!
    @handle-file!
    @handle-recursive!
    @handle-replace!
    @handle-selector!

  handle-jsx ->
    return unless @options.jsx
    @options.extensions.push('jsx')
    if @options.parser.0 == 'acorn'
      require 'acorn-jsx'
      @options.parser.1.plugins = {jsx: true}

  handle-version ->
    return unless @options.version
    version-string = "grasp v#version"
    @callback version-string
    @exit 0, version-string
    return

  handle-file ->
    if @options.file?
      @selector-from-file!
    else
      @selector-from-pos!

  handle-help ->
    return unless @options.help
    help-string = @get-help!
    @callback help-string
    @exit 0, help-string
    return

  handle-recursive ->
    @targets = (if options.recursive then ['.'] else ['-']) unless @targets.length

  handle-selector ->
    unless @selector?
      @error 'Error: No selector specified.'
      @help-string = @get-help!
      @callback @help-string
      @exit 2, @help-string
      return

  handle-replace-file ->
    return unless @options.replace-file
    try
      @replacement = @fs.read-file-sync that, 'utf8' .replace /([\s\S]*)\n$/ '$1'
    catch
      @error "Error: No such file '#{@options.replace-file}'."
      @exit 2
      return

  is-replace ->
    @options.replace? or @options.replace-func

  handle-replace ->
    if is-replace?
      @replacement = that
    else
      @handle-replace-file!