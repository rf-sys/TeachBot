class NotificationItem extends React.Component {
    constructor(props) {
        super(props)
    }

    isFresh() {
        let created_at = this.props.notification.created_at;
        return moment().utc().valueOf() < moment(created_at).utc().add(1, 'day')

    }

    render() {
        let unread_notification_mark = <small className="text-danger">New!</small>;

        return (
        <a href={this.props.notification.link}
           className="animated list-group-item list-group-item-action flex-column align-items-start">
            <div className="d-flex w-100 justify-content-between">
                <h5 className="mb-1">{this.props.notification.title}</h5>
                {this.isFresh() ? unread_notification_mark : null}
            </div>
            <p className="mb-1">
                {this.props.notification.text}
            </p>
            <small>{moment(this.props.notification.created_at).fromNow()}</small>
        </a>
        )
    }
}