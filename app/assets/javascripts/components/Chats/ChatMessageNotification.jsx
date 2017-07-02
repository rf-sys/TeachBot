class ChatMessageNotification extends React.Component {
    constructor(props) {
        super(props)
    }

    hide() {
        this.props.hideNotification();
    }

    render() {
        if (this.props.notification.show)
            return (
                <div className={`alert alert-${this.props.notification.status} load-fade`}>
                    <button type="button" className="close" onClick={this.hide.bind(this)}>
                        <span aria-hidden="true">&times;</span>
                    </button>
                    {this.props.notification.message}
                </div>
            );
        else return <div></div>
    }
}