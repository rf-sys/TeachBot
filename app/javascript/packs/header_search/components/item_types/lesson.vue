<template>
    <a v-bind:href="'/courses/' + lesson.course.slug + '/lessons/' + lesson.slug"
       class="round-0 list-group-item list-group-item-action flex-column align-items-start">
        <div class="row align-items-center">
            <div class="col">
                <h5 class="mb-1">{{lesson.title}}</h5>
                <small>{{ updated_at }}</small>
                <p class="mb-1">{{lesson.description}}</p>
                <p class="mb-1">
                    <small>Course: {{lesson.course.title}}</small>
                </p>
            </div>
        </div>
    </a>
</template>

<script>
    import momentJs from 'moment'

    export default {
        props: ['lesson'],

        computed: {
            updated_at: function () {
                return momentJs(this.lesson.updated_at).format('LLL');
            }
        }
    }
</script>