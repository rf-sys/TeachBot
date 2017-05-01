<template>
    <div class="col-lg mr-auto">
        <div>
            <search-input v-model="text" v-bind:loading="loading"></search-input>
            <search-results v-bind:data="data"></search-results>
        </div>
    </div>
</template>

<script>
    import _ from 'lodash'
    import * as api from './../api'

    import clickOutside from '../../helpers/click_outside'

    import SearchInput from './search_input.vue'
    import SearchResults from './search_results.vue'

    export default {
        components: {SearchInput, SearchResults},
        mixins: [clickOutside],
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
                    api.find(this.text).then(({data}) => {
                        this.data = data;
                        this.loading = false;
                    }).catch(() => {
                        this.loading = false;
                    });
                }, 500
            ),

            clickOutside() {
                console.log('clickOutside');
                this.data = [];
            }
        },
    }
</script>