<template>
    <li class="nav-item hidden-md-down">
        <div class="dropdown">
            <a class="nav-link active bell" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
               @click="showNotificationsHandler" id="notifications_app_bell">
                <i class="fa fa-bell" aria-hidden="true"></i>
                <unread-notifications-counter :count="unread_notifications"></unread-notifications-counter>
            </a>
            <div class="dropdown-menu dropdown-menu-right notifications_dropDown" id="notifications_app_dropDown"
                 v-static-dropdown>
                <div class="triangle"></div>
                <div class="list-group notifications_list">
                    <notifications :notifications="notifications" :loaded_once="loaded_once"></notifications>
                    <button class="btn btn-outline-primary" id="notifications_app_load_button"
                            @click="loadNotifications(current_page + 1)"
                            v-if="!is_last_page" v-bind:disabled="loading_button">
                        {{ loading_button ? 'Loading...' : 'Load more' }}
                    </button>
                </div>
            </div>
        </div>
    </li>
</template>

<script>
    import * as api from './../api'
    import Notifications from './notifications.vue'
    import UnreadNotificationsCounter from './unread-notifications-counter.vue'

    import staticDropdown from './../../../misc/directives/static_dropdown'

    export default {
        components: {Notifications, UnreadNotificationsCounter},

        storageKey: 'notifications:unread_notifications_count',

        directives: {staticDropdown},

        data() {
            return {
                loaded_once: false,
                loading_button: false,
                notifications: [],
                current_page: 0,
                total_pages: 0,
                unread_notifications: 0,
            }
        },

        computed: {
            is_last_page() {
                return this.current_page >= this.total_pages;
            }
        },

        methods: {
            showNotificationsHandler() {
                if (!this.loaded_once)
                    this.loadNotifications();

                let storageCount = window.sessionStorage.getItem(this.storageKey);

                console.log(storageCount);

                if (parseInt(storageCount))
                    api.clearUnreadNotifications().then(() => this.unread_notifications = 0)

            },

            loadNotifications(page = 1) {
                this.loading_button = true;

                return api.loadNotifications(page)
                    .then(({data}) => {
                        this.notifications = this.notifications.concat(data.notifications);
                        this.current_page = data.current_page;
                        this.total_pages = data.total_pages;
                    })
                    .then(() => {
                        this.loaded_once = true;
                        this.loading_button = false;
                    });
            },

            loadUnreadNotificationsCount() {
                return api.loadUnreadNotificationsCount().then(({data}) => {
                    this.unread_notifications = data.count;
                });
            }
        },

        watch: {
            unread_notifications(newCount) {
                return window.sessionStorage.setItem(this.storageKey, newCount);
            }
        },

        mounted() {
            $(document).unbind('notifications:receive').bind('notifications:receive', (e, {notification}) => {
                this.unread_notifications = this.unread_notifications + 1;
                this.notifications.unshift(notification);
            });

            let storageCount = parseInt(window.sessionStorage.getItem(this.storageKey));

            if (storageCount)
                return this.unread_notifications = storageCount;

            this.loadUnreadNotificationsCount();
        }
    }
</script>

<style scoped>
    .bell {
        position: relative;
    }

    .notifications_dropDown {
        padding: 0;
    }

    .notifications_list {
        font-size: 14px;
        max-height: 500px;
        overflow: auto;
        width: 400px;
        padding: 0;
    }

    .triangle {
        position: absolute;
        top: -12px;
        right: 2px;
        z-index: 100;
        width: 0;
        height: 0;
        border-style: solid;
        border-width: 0 12.5px 15px 12.5px;
        border-color: transparent transparent #ffffff transparent;
    }
</style>