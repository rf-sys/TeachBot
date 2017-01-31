class Notifications extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            show: false,
            notifications: [],
            current_page: 0,
            last_page: true,
            count: 0,
            loaded_once: false,
            loading: false,
            loading_btn: false
        };

        this.loadNotifications = this.loadNotifications.bind(this);
        this.getNotificationsCount = this.getNotificationsCount.bind(this);
        this.clearNotificationsCount = this.clearNotificationsCount.bind(this);
        this.addNotification = this.addNotification.bind(this);
    }

    componentDidMount() {
        this.getNotificationsCount();

        $(document).unbind('notifications:receive').on('notifications:receive', (event, data) => {
            return this.addNotification(event, data)
        });
    }

    addNotification(event, data) {
        let notifications = this.state.notifications.slice();
        let count = this.state.count;

        notifications.push(data.notification);
        this.setState({notifications: notifications, count: count + 1});
        sessionStorage.setItem('notifications:count', this.state.count)
    }

    getNotificationsCount() {
        let count;
        if (count = sessionStorage.getItem('notifications:count')) {
            this.setState({count: parseInt(count)});
        }
        else {
            this.setNotificationsCount();
        }
    }

    clearNotificationsCount() {
        $.ajax({
            type: 'PUT',
            url: '/notifications/mark_all_as_read',
            success: () => {
                this.setState({count: 0});
                sessionStorage.removeItem('notifications:count');
            }
        });
    }

    mark_all_as_read() {
        let notifications = this.state.notifications.slice();

        notifications.forEach((notification) => {
            return notification.readed = true;
        });

        this.setState({notifications: notifications});
    }

    setNotificationsCount() {
        let ajax = $.post('/notifications/count');

        ajax.done((r) => {
            sessionStorage.setItem('notifications:count', r.count);
            this.setState({count: parseInt(r.count)});
        });
    }

    toggleNotifications(e) {
        e.preventDefault();
        if (!this.state.loaded_once)
            this.loadNotifications();

        this.setState({show: !this.state.show, loaded_once: true});

        if (!this.state.show && this.state.count > 0) this.clearNotificationsCount();
    }

    loadNotifications() {
        if (this.state.current_page == 0) this.setState({loading: true});

        if (this.state.current_page > 0) this.setState({loading_btn: true});

        let page = this.state.current_page + 1;

        let ajax = $.get('/notifications?page=' + page);
        ajax.done((r) => {
            let notifications = r.notifications;

            if (page > 1) {
                notifications = this.state.notifications.slice();
                r.notifications.forEach((notification) => {
                    notifications.push(notification)
                })
            }

            this.setState({notifications: notifications, current_page: r.current_page, last_page: r.last_page});
        });

        ajax.always(() => this.setState({loading: false, loading_btn: false}));
    }

    render() {
        let loading_cog = (
            <div className="text-center">
                <i className="fa fa-spinner fa-pulse fa-3x fa-fw"/>
                <span className="sr-only">Loading...</span>
            </div>
        );

        let loading_btn = (
            <div>
                <i className="fa fa-spinner fa-pulse fa-3x fa-fw" style={{fontSize: '14px'}}/>
                <span className="sr-only">Loading...</span> Loading
            </div>
        );

        let older_notifications_button = (
            <button className="btn btn-outline-secondary btn-block"
                    onClick={this.loadNotifications}>
                {this.state.loading_btn ? loading_btn : 'Load more'}
            </button>
        );

        let sorted_notification_items = _.orderBy(this.state.notifications,
            ['created_at', 'readed'], ['desc', 'desc']);

        let notifications = (
            <div className="list-group">
                {sorted_notification_items.map((n) => {
                    return <NotificationItem notification={n} key={n.id}/>;
                })}
                {!this.state.last_page ? older_notifications_button : null}
            </div>
        );

        let notifications_block = (
            <div className="notifications-block box-shadow-block">

                {
                    (this.state.loading) ? loading_cog : (this.state.notifications.length) ? notifications :
                            <div><p className="lead text-center">No notifications</p></div>
                }
            </div>
        );
        let unread_notifications_count = (
            <div className="notifications-block_counter_wrapper animated">
                <div className="live_light notifications-block_counter_inner_live"></div>
                <div className="animated badge-danger notifications-block_counter_inner_counter">
                    {this.state.count}
                </div>
            </div>
        );

        return (
            <div className="notifications-bell">
                <a className="nav-link active" href="#" onClick={this.toggleNotifications.bind(this)}>
                    <ReactCSSTransitionGroup transitionName={{enter: "zoomIn", leave: "zoomOut"}}
                                             transitionEnterTimeout={1000} transitionLeaveTimeout={1000}>
                        {(this.state.count) ? unread_notifications_count : ''}
                    </ReactCSSTransitionGroup>
                    <i className="fa fa-bell" aria-hidden="true"/>
                </a>
                {(this.state.show) ? notifications_block : ''}
            </div>
        )
    }
}