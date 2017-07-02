<template>
    <div>
        <a :href="notification.link"
           class="animated fadeIn list-group-item list-group-item-action flex-column align-items-start">
            <div class="d-flex w-100 justify-content-between">
                <h5 class="mb-1">{{notification.title}}</h5>
                <new-notification-mark :created_at="notification.created_at"></new-notification-mark>
            </div>
            <p class="mb-1">
                {{notification.text}}
            </p>
            <small>{{created_at}}</small>
        </a>
    </div>
</template>

<script>
import moment from 'moment'
import NewNotificationMark from './new-notifiaction-mark.vue'
export default {
    props: ['notification'],
    components: {NewNotificationMark},
    computed: {
        created_at: function() {
            return moment(this.notification.created_at).fromNow();
        }
    }
}
</script>

<style>

</style>