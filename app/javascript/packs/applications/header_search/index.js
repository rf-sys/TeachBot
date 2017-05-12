import Vue from 'vue/dist/vue.esm'
import SearchPanel from './components/search_panel.vue'
import TurbolinksAdapter from 'vue-turbolinks';

document.addEventListener("turbolinks:load", () => {
    new Vue({
        el: '#header_search_app',
        render: h => h(SearchPanel),
        mixins: [TurbolinksAdapter]
    });
});
