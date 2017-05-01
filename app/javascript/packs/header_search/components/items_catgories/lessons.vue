<template>
    <div>
        <div class="bg-primary text-white list-group-item round-0">
            Lessons
        </div>
        <div v-if="lessons.length">
            <div class="list-group">
                <lesson v-for="lesson in lessons" v-bind:lesson="lesson" :key="lesson.id"></lesson>
            </div>
        </div>
        <div v-else>
            <not-found></not-found>
        </div>
    </div>
</template>

<script>
    import Lesson from './../item_types/lesson.vue'
    import NotFound from './../item_types/not_found.vue'

    export default {
        props: ['lessons'],
        components: {Lesson, NotFound}
    }
</script>