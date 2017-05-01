import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import clickOutside from './../helpers/click_outside'

import {find} from './api'
import _ from 'lodash'

import SearchResults from './components/search_results.vue'

Vue.component('search-results', SearchResults);

document.addEventListener("turbolinks:load", () => {
    console.log('Vue loaded');
    new Vue({
        el: '#header_search_panel_app',
        mixins: [TurbolinksAdapter, clickOutside],

        data() {
            return {
                text: "",
                data: {},
                loading: false,
            }
        },

        watch: {
            text(newValue) {
                if (newValue) {
                    this.loading = true;
                    return this.search();
                } else {
                    this.data = {};
                }
            }
        },

        methods: {
            search: _.debounce(
                function () {
                    find(this.text).then(({data}) => {
                        this.data = data;
                        this.loading = false;
                    }).catch(() => {
                        this.loading = false;
                    });
                }, 500
            ),

            clickOutside() {
                this.data = [];
            }
        },
    });
});
