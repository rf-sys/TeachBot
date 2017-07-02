<template>
    <span class="animated badge badge-danger counter" v-if="count" id="notifications_app_counter">
        {{count}}
    </span>
</template>

<script>
    export default {
        props: ['count']
    }
</script>

<style>
    .counter {
        position: absolute;
        right: -5px;
        top: 5px;
    }
</style>