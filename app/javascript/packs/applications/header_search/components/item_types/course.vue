<template>
    <a v-bind:href="'/courses/' + course.slug"
       class="round-0 list-group-item list-group-item-action flex-column align-items-start">
        <div class="row align-items-center">
            <div class="col-md-4" v-if="course.poster">
                <img v-bind:src="course.poster"/>
            </div>
            <div class="col">
                <h5 class="mb-1">{{course.title}}</h5>
                <small>{{ updated_at }}</small>
                <p class="mb-1">{{course.description}}</p>
                <p class="mb-1">
                <span class="badge badge-primary course_tag" v-for="tag in course.tags">
                    {{tag.name}}
                </span>
                </p>
            </div>
        </div>
    </a>
</template>

<script>
    import momentJs from 'moment'

    export default {
        props: ['course'],

        computed: {
            updated_at: function () {
                return momentJs(this.course.updated_at).format('LLL');
            }
        }
    }
</script>