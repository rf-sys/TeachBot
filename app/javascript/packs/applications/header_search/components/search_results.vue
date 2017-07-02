<template>
    <div class="search_result_panel_wrapper">
        <div class="search_result_panel rounded-0" id="header_search_app_results_panel">

            <div v-if="anyData" id="header_search_app_results_list">
                <div v-for="(items, category) in data">
                    <courses v-bind:courses="items" v-if="category == 'courses'"></courses>
                    <lessons v-bind:lessons="items" v-if="category == 'lessons'"></lessons>
                    <users v-bind:users="items" v-if="category == 'users'"></users>
                </div>
            </div>
            <div v-else-if="loaded_once" class="not_found text-center" id="header_search_app_not_found">
                <i class="fa fa-eye-slash" aria-hidden="true"></i> Not found
            </div>
        </div>
    </div>
</template>

<script>
    import Courses from './items_catgories/courses.vue'
    import Lessons from './items_catgories/lessons.vue'
    import Users from './items_catgories/users.vue'

    export default {
        props: ['data', 'loaded_once'],
        components: {Courses, Lessons, Users},

        computed: {
            anyData() {
                return Object.keys(this.data).length > 0;
            }
        }
    }
</script>

<style scoped lang="scss">
    .search_result_panel_wrapper {
        position: relative;
    }

    .search_result_panel {
        position: absolute;
        background: white;
        width: 100%;
        margin-top: 5px;
        z-index: 100;
        box-shadow: 0 0 10px;

        max-height: 600px;
        overflow: auto;
    }

    .not_found {
        padding: 15px;
        font-size: 18px;
    }
</style>