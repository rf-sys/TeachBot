<template>
    <div class="col-lg mr-auto" id="header_search_app_search_panel" v-click-outside="clickOutside">
        <div class="search_field_wrapper">
            <search-input v-model="text" v-bind:loading="loading"></search-input>
            <search-results v-bind:data="data" v-bind:loaded_once="loaded_once"></search-results>
        </div>
    </div>
</template>

<script>
    import _ from 'lodash'

    import {find} from './../api'

    import SearchInput from './search_input.vue'
    import SearchResults from './search_results.vue'
    import ClickOutside from './../../../misc/directives/click_outside'

    export default {
        components: {SearchInput, SearchResults},
        directives: {ClickOutside},
        data() {
            return {
                text: "",
                data: {},
                loading: false,
                loaded_once: false
            }
        },

        watch: {
            text(newValue) {
                if (newValue)
                    return this.search();
                else {
                    this.data = {};
                    this.loaded_once = false;
                }
            }
        },

        methods: {
            search: _.debounce(
                function () {
                    this.loading = true;
                    find(this.text).then(({data}) => {
                        this.data = data;
                        this.loaded_once = true;
                        this.loading = false;
                    }).catch(() => {
                        this.loaded_once = true;
                        this.loading = false;
                    });
                }, 500
            ),

            clickOutside() {
                this.loaded_once = false;
                this.data = {};
            }
        },
    }
</script>