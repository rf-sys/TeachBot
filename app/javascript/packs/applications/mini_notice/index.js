import Vue from 'vue/dist/vue.esm'
import App from './components/app.vue'
import TurbolinksAdapter from 'vue-turbolinks';

document.addEventListener("turbolinks:load", () => {
  let el = document.getElementById('mini_notice_vueapp');
  if (el) {
    new Vue({
      el: '#mini_notice_vueapp',
      data: {
        message: el.dataset.message,
        type: el.dataset.type
      },
      template: `<App :message="message" :type="type"/>`,
      components: {App},
      mixins: [TurbolinksAdapter]
    });
  }
});
