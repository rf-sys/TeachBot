class NotificationsList extends React.Component {
    constructor(props) {
        super(props);
        // status, notifications
    }

    render() {
        let loading = (
            <div className="text-center">
                <i className="fa fa-spinner fa-pulse fa-3x fa-fw"/>
                <span className="sr-only">Loading...</span>
            </div>
        );

        let sorted_notifications = _.orderBy(this.props.notifications,
            ['created_at', 'readed'], ['desc', 'desc']);

        if (this.props.status)
            return loading;
        else if (this.props.notifications.length)
            return (
              <div>
                  {sorted_notifications.map((n) => <NotificationItem notification={n} key={n.id} />)}
              </div>
            );
        else
            return <div><p className="lead text-center">No notifications</p></div>

    }
}