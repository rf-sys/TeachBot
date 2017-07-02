import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import App from './components/app.vue'

document.addEventListener("turbolinks:load", () => {
    if (document.getElementById('notifications_vueapp')) {
        new Vue({
            el: '#notifications_vueapp',
            render: h => h(App),
            mixins: [TurbolinksAdapter],
        })
    }
});
