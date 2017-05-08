// phantomjs promise polyfill (to prevent promise error)
import es6_promise from 'es6-promise';
es6_promise.polyfill();
// global packs
require('./header_search/main.js');