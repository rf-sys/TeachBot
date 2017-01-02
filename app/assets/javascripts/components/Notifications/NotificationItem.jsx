class NotificationItem extends React.Component {
    constructor(props) {
        super(props)
    }

    deleteNotification() {
        this.props.deleteNotification(this.props.notification);
    }

    render() {
        let link = (
            <div className="col-sm">
                <a href={this.props.notification.link} className="btn btn-block btn-outline-primary">
                    Visit&nbsp;
                    <i className="fa fa-location-arrow" aria-hidden="true"/>
                </a>
            </div>
        );
        return (
            <div className="animated card card-block">
                <h4 className="card-title">{this.props.notification.title}</h4>
                <p className="card-text">
                    {this.props.notification.text}
                </p>
                <div className="row">
                    {(this.props.notification.link) ? link : ''}
                    <div className="col-sm">
                        <button className="btn btn-block btn-outline-danger"
                                onClick={this.deleteNotification.bind(this)}>
                            Delete&nbsp;
                            <i className="fa fa-trash" aria-hidden="true"/>
                        </button>
                    </div>
                </div>
            </div>
        )
    }
}