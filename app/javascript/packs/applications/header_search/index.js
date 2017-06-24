import Vue from 'vue/dist/vue.esm'
import App from './components/app.vue'
import TurbolinksAdapter from 'vue-turbolinks';

document.addEventListener("turbolinks:load", () => {
    new Vue({
        el: '#header_search_app',
        render: h => h(App),
        mixins: [TurbolinksAdapter]
    });
});
