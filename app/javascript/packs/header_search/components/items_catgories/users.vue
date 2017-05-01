<template>
    <div>
        <div class="bg-primary text-white list-group-item round-0">
            Users
        </div>
        <div v-if="users.length">
            <div class="list-group">
                <user v-for="user in users" v-bind:user="user" :key="user.id"></user>
            </div>
        </div>
        <div v-else>
            <not-found></not-found>
        </div>
    </div>
</template>

<script>
    import User from './../item_types/user.vue'
    import NotFound from './../item_types/not_found.vue'

    export default {
        props: ['users'],
        components: {User, NotFound}
    }
</script>