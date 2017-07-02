// phantomjs promise polyfill (to prevent promise error)
import {polyfill} from 'es6-promise';

polyfill();

// global packs
require('./applications/header_search');
require('./applications/notifications');
require('./applications/mini_notice');