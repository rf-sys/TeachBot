<template>
    <a v-bind:href="'/users/' + user.slug"
       class="round-0 list-group-item list-group-item-action flex-column align-items-start">
        <div class="row align-items-center">
            <div class="col-md-2" v-if="user.avatar">
                <img v-bind:src="user.avatar"/>
            </div>
            <div class="col-md">
                <h5 class="mb-1">{{user.username}}</h5>
            </div>
        </div>
    </a>
</template>

<script>
    export default {
        props: ['user'],
    }
</script>