<template>
    <div class="search_result_panel_wrapper">
        <div class="search_result_panel rounded-0">

            <div v-for="(items, category) in data">
                <courses v-bind:courses="items" v-if="category == 'courses'"></courses>
                <lessons v-bind:lessons="items" v-if="category == 'lessons'"></lessons>
                <users v-bind:users="items" v-if="category == 'users'"></users>
            </div>

        </div>
    </div>
</template>

<script>
    import Courses from './items_catgories/courses.vue'
    import Lessons from './items_catgories/lessons.vue'
    import Users from './items_catgories/users.vue'

    export default {
        props: ['data'],
        components: {Courses, Lessons, Users},
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
</style>