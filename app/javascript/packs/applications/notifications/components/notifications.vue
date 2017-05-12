<template>
    <div>
        <div v-if="!loaded_once" class="text-center">
            <i class="fa fa-spinner fa-pulse fa-3x fa-fw notifications_loading_spinner"></i>
            <span class="sr-only">Loading...</span>
        </div>

        <div v-else-if="notifications.length" v-for="notification in notifications">
            <notification :key="notification.id" :notification="notification"></notification>
        </div>

        <div class="text-center" v-else>
            No notifications
        </div>
    </div>
</template>

<script>
    import Notification from './notification.vue'

    export default {
        components: {Notification},
        props: ['notifications', 'loaded_once']
    }
</script>

<style scoped>
    .notifications_loading_spinner {
        margin: 15px;
    }
</style>