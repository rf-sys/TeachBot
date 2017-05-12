<template>
    <div>
        <div class="bg-primary text-white list-group-item round-0">
            Courses
        </div>
        <div class="list-group">
            <course v-for="course in courses" v-bind:course="course" :key="course.id"></course>
        </div>
    </div>
</template>

<script>
    import Course from './../item_types/course.vue'

    export default {
        props: ['courses'],
        components: {Course}
    }
</script>