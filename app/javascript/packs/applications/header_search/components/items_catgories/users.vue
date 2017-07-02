<template>
    <div>
        <div class="bg-primary text-white list-group-item round-0">
            Users
        </div>
        <div class="list-group">
            <user v-for="user in users" v-bind:user="user" :key="user.id"></user>
        </div>
    </div>
</template>

<script>
    import User from './../item_types/user.vue'

    export default {
        props: ['users'],
        components: {User}
    }
</script>