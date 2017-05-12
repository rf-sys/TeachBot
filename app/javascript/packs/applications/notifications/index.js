import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import App from './components/app.vue'

document.addEventListener("turbolinks:load", () => {
    if (document.getElementById('notifications_app')) {
        new Vue({
            el: '#notifications_app',
            render: h => h(App),
            mixins: [TurbolinksAdapter],
        })
    }
});
