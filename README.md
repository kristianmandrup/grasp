grasp
====
JavaScript structural search, replace, and refactor.

[Demo](http://graspjs.com#demo), [documentation](http://graspjs.com/docs/), and more: [graspjs.com](http://graspjs.com).

Install: `npm install -g grasp`.

`grasp --help` for help.

[MIT license](https://github.com/gkz/grasp/blob/master/LICENSE).

### Development

Watch `/src` compile and output to `/lib` via `npm run dev` which runs livescript compiler in watch mode:

`lsc -wco lib src`

`npm t` to run tests in `/tests` folder which runs `test` (mocha) task in `Makefile`:

`$(MOCHA) --reporter dot --ui tdd --compilers ls:$(LS)`