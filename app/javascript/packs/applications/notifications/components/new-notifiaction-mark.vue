<template>
    <div>
        <small class="text-danger font-weight-bold" v-if="is_new">New!</small>
    </div>

</template>

<script>
import moment from 'moment'
export default {
    props: ['created_at'],

    computed: {
        is_new: function () {
            return moment().utc().valueOf() < moment(this.created_at).utc().add(1, 'day')
        }
    }
}
</script>

<style>

</style>