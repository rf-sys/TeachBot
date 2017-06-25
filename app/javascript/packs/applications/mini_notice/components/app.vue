<template>
    <div>
        <transition name="left_top_notification_transition"
                    enter-active-class="animated slideInLeft"
                    leave-active-class="animated bounceOut">
            <div v-show="show" class="notification">
                <success-notification v-if="type == 'success'" :message="message"></success-notification>
                <info-notification v-if="type == 'info'" :message="message"></info-notification>
                <danger-notification v-if="type == 'danger'" :message="message"></danger-notification>
            </div>
        </transition>
    </div>
</template>

<script>
  import SuccessNotification from './success_notice.vue';
  import InfoNotification from './info_notice.vue';
  import DangerNotification from './danger_notice.vue';

  export default {
    props: ['message', 'type'],
    components: {SuccessNotification, InfoNotification, DangerNotification},
    data() {
      return {
        show: false,
      }
    },

    mounted() {
      this.show = true;
    },

    watch: {
      show: function () {
        setTimeout(() => this.show = false, 4000);
      }
    },

  }
</script>

<style scoped>
    .notification {
        position: absolute;
        max-width: 400px;
        top: 65px;
        left: 5px;
    }
</style>