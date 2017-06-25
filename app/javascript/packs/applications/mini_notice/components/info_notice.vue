<template>
    <div class="alert alert-info" role="alert">
        {{message}}
    </div>
</template>

<script>
  export default {
    props: ['message']
  }
</script>