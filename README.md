# PLEASE NOTE, THIS PROJECT IS NO LONGER BEING MAINTAINED
# Glider - angularjs UI slider

Glider - angularjs slider with no dependencies. Dead simple, < 200 LOC.

<a href="https://evrone.com/?utm_source=github.com">
  <img src="https://evrone.com/logo/evrone-sponsored-logo.png"
       alt="Sponsored by Evrone" width="231">
</a>

## Demo

Demo is available here: http://evrone.github.io/glider

## Getting Started
### Installation

##### Bower

`bower install glider`

##### Ruby-on-Rails

Add this to your Gemfile

`
gem 'glider-rails'
`
and

`bundle install`

After that you can add the file to sprockets:

` //= require glider `

### Usage

Add module as a dependency:

```javascript
angular.module('myApp', ['glider']);
```

And then in HTML:

```html
<slider min="21" max="130" value="age"></slider>
```

To defer value update until `mouseup`:

```html
<slider defer_update min="21" max="130" value="age"></slider>
```

Show value in handle:

```html
<slider show_value_in_handle min="21" max="130" value="age"></slider>
```

Use increments with snapping:

```html
<slider min="50" max="500" increments="100,200,300,400" value="price"></slider>
```

##### CoffeeScript to JavaScript compilation

To convert the `src/glider.coffee` to javascript, use coffeescript compiler.
Install it with:

```
npm -g install coffee-script
```

Then compile the file with:

```
coffee -c -o . --map src/glider.coffee
```

This will compile the src/glider.coffee to glider.js and generate the source map.

##### Minification

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


## Contributing

Please read [Code of Conduct](CODE-OF-CONDUCT.md) and [Contributing Guidelines](CONTRIBUTING.md) for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, 
see the [tags on this repository](https://github.com/evrone/glider/tags). 

## Changelog

The changelog is [here](CHANGELOG.md).

## Authors

* [Valentin Vasilyev](https://github.com/Valve) 
* [Dmitry Karpunin](https://github.com/KODerFunk) 

See also the list of [contributors](https://github.com/evrone/glider/contributors) who participated in this project.

## License

This project is licensed under the [MIT License](LICENSE).

[uglifyjs]: https://github.com/mishoo/UglifyJS
[closure]: http://closure-compiler.appspot.com
