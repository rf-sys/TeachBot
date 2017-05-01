<template>
    <div class="search_field_wrapper">
        <i class="fa fa-search search_icon" aria-hidden="true"></i>
        <input type="search" class="form-control input"
               v-bind:value="value" v-on:input="updateText($event.target.value)"
               placeholder="Search courses, lessons, users, tags"
               name="global_search_input"/>
        <i class="fa fa-spinner fa-pulse fa-3x fa-fw loading_icon" v-if="loading"></i>
    </div>
</template>

<script>
    export default {
        props: ['value', 'loading'],
        methods: {
            updateText(text) {
                this.$emit('input', text.trim());
            }
        },
    }
</script>


<style scoped>
    .search_field_wrapper {
        width: 100%;
        position: relative;
    }

    .input {
        width: 100%;
        padding-left: 35px;
    }

    .search_icon {
        position: absolute;
        left: 12px;
        top: 10px;
        font-size: 18px
    }

    .loading_icon {
        position: absolute;
        right: 12px;
        top: 10px;
        font-size: 18px
    }
</style>
