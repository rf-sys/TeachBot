<template>
    <div>
        <div class="bg-primary text-white list-group-item round-0">
            Lessons
        </div>
        <div class="list-group">
            <lesson v-for="lesson in lessons" v-bind:lesson="lesson" :key="lesson.id"></lesson>
        </div>
    </div>
</template>

<script>
    import Lesson from './../item_types/lesson.vue'

    export default {
        props: ['lessons'],
        components: {Lesson},
    }
</script>