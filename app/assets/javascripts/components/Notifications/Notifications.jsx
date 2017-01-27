class Notifications extends React.Component {
    constructor(props) {
        super(props);
        this.state = {show: false, notifications: [], count: 0, loaded_once: false, loading: false};

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
        /*
         $(document).unbind('notifications:count:clear').on('notification:count:clear', this.clearNotificationsCount());
         */
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
        this.setState({count: 0})
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
    }

    loadNotifications() {
        this.setState({loading: true});
        let ajax = $.get('/notifications');
        ajax.done((r) => {
            this.setState({notifications: r.notifications});
        });

        ajax.always(() => this.setState({loading: false}));
    }

    deleteNotificationRequest(notification) {
        let ajax = $.ajax({
            url: '/notifications/' + notification.id,
            type: 'DELETE'
        });

        ajax.done((r) => {
            console.log(r);
            return true
        });

        ajax.fail((r) => {
           console.log(r);
            return true
        });

        return true
    };

    deleteNotification(notification) {
        if (this.deleteNotificationRequest(notification)) {
            let notifications = this.state.notifications.filter((item) => {
                return item.id != notification.id
            });

            sessionStorage.setItem('notifications:count', notifications.length);

            this.setState({notifications: notifications, count: notifications.length});

        }
    }

    render() {
        let loading_cog = (
            <div className="text-xs-center">
                <i className="fa fa-spinner fa-pulse fa-3x fa-fw"/>
                <span className="sr-only">Loading...</span>
            </div>
        );

        let sorted_notification_items = _.orderBy(this.state.notifications, ['readed', 'created_at'], ['desc', 'desc']);
        let notifications = (
                <ReactCSSTransitionGroup transitionName={{enter: "zoomIn", leave: "zoomOut"}}
                                         transitionEnterTimeout={1000} transitionLeaveTimeout={1000}>
                {sorted_notification_items.map((n, i) => {
                    return <NotificationItem notification={n} key={i}
                                             deleteNotification={this.deleteNotification.bind(this)}/>;
                })}
                </ReactCSSTransitionGroup>
        );

        let notifications_block = (
            <div className="notifications-block box-shadow-block">
                {
                    (this.state.loading) ? loading_cog : (this.state.notifications.length) ? notifications :
                            <div><h2 className="text-xs-center">Notifications not found</h2></div>
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