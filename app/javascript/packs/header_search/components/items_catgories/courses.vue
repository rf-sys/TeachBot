<template>
    <div>
        <div class="bg-primary text-white list-group-item round-0">
            Courses
        </div>
        <div v-if="courses.length">
            <div class="list-group">
                <course v-for="course in courses" v-bind:course="course" :key="course.id"></course>
            </div>
        </div>
        <div v-else>
            <not-found></not-found>
        </div>
    </div>
</template>

<script>
    import Course from './../item_types/course.vue'
    import NotFound from './../item_types/not_found.vue'

    export default {
        props: ['courses'],
        components: {Course, NotFound}
    }
</script>