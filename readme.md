# Glider - angularjs UI slider

Glider - angularjs slider with no dependencies. Dead simple - 74 LOC.

## Demo

Demo is available here: http://evrone.github.io/glider

## Installation

### Bower

`bower install glider`

### Ruby-on-Rails

Add this to your Gemfile

`
gem 'glider-rails'
`
and

`bundle install`

After that you can add the file to sprockets:

` //= require glider `

## Usage

Add module as a dependency:

```javascript
angular.module('myApp', ['glider']);
```

And then in HTML:

```html
<slider min="21" max="130" value="age"></slider>
```

## CoffeeScript to JavaScript compilation

To convert the `src/glider.coffee` to javascript, use coffeescript compiler.
Install it with:

```
npm -g install coffee-script
```

Then compile the file with:

```
coffee -c -o . src/glider.coffee
```

This will compile the src/glider.coffee to glider.js

## Minification

To minify the file I recommend using [uglifyjs][uglifyjs]
If you don't have it installed, install it with:

```
npm -g install uglify-js
```

Then run the minification with:

```
uglifyjs glider.js > glider.min.js -mc
```

`-mc` tells uglifier to (m)angle and (c)ompress the input code.

If you don't have node.js installed on your machine, you can create a minified version of the library with
online services, such as [Google Closure compiler][closure]

### Authors

* Valve - Valentin Vasilyev
* KODerFunk - Dmitry Karpunin

Inspired by a plunkr snippet

### Licence

This code is [MIT][mit] licenced:

Copyright (c) 2013 Valentin Vasilyev, Dmitry Karpunin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[mit]: http://www.opensource.org/licenses/mit-license.php
[murmur]: http://en.wikipedia.org/wiki/MurmurHash
[research]: https://panopticlick.eff.org/browser-uniqueness.pdf
[phantomjs]: http://phantomjs.org/
[uglifyjs]: https://github.com/mishoo/UglifyJS
[closure]: http://closure-compiler.appspot.com
