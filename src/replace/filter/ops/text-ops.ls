module.exports =
  replace ->
    let args
      @text-operations.push (.replace args.0, args.1)
  lowercase ->
    @text-operations.push (.to-lower-case!)
  uppercase ->
    @text-operations.push (.to-upper-case!)
  capitalize ->
    @text-operations.push capitalize
  uncapitalize ->
    @text-operations.push -> (it.char-at 0).to-lower-case! + it.slice 1
  camelize ->
    @text-operations.push camelize
  dasherize ->
    @text-operations.push dasherize
  trim ->
    @text-operations.push (.trim!)

  substring ->
    let args
      @text-operations.push (.substring args.0, args.1)
  substr ->
    let args
      @text-operations.push (.substr args.0, args.1)
  str-slice ->
    let args
      @text-operations.push (.slice args.0, args.1)