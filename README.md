# grasp

JavaScript structural search, replace, and refactor.

[Demo](http://graspjs.com#demo), [documentation](http://graspjs.com/docs/), and more: [graspjs.com](http://graspjs.com).

Install: `npm install -g grasp`.

`grasp --help` for help.

## TODO

Complete test suite with tests for full (~95%) coverage and make all tests pass!

## Development

Watch `/src` compile and output to `/lib` via

`npm run dev`

which runs livescript compiler in watch mode:

`lsc -wco lib src`

## Testing

`npm t` to run tests in `/tests` folder which runs `test` (mocha) task in `Makefile`:

`$(MOCHA) --reporter dot --ui tdd --compilers ls:$(LS)`

It currently uses the [TDD interface](https://mochajs.org/#tdd)

When debugging or refactoring, you can limit which tests to run, see [CLI usage](https://mochajs.org/#usage)

## Test Coverage

`npm run cover` (see `coverage` entry in `Makefile`)

## License

[MIT license](https://github.com/gkz/grasp/blob/master/LICENSE).
