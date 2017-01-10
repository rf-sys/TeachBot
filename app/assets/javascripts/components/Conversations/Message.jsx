class Message extends React.Component {
    constructor(props) {
        super(props);
        this.markMessageAsRead = this.markMessageAsRead.bind(this);
        this.state = {read: this.props.message.read}
    }

    componentDidMount() {
        if (!this.props.message.read) {
            this.markMessageAsRead();
        }

    };

    markMessageAsRead() {
        let ajax = $.post(`/api/messages/read`, {id: this.props.message.id});

        ajax.done((resp) => {
            this.setState({read: true});
        });

    }


    render() {
        let mark_as_read = (
            <button className="btn btn-sm btn-outline-info" onClick={this.markMessageAsRead}>Mark as read</button>
        );
        return (
            <div className="media">
                <a className="media-left" href="#">
                    <img className="media-object chat_user_avatar" src={this.props.message.user.avatar}
                         alt="Not found"/>
                </a>
                <div className="media-body">
                    <h4 className="media-heading">{this.props.message.user.username}</h4>
                    {this.props.message.text}<br/>
                    <div>
                        <small>{momentJs(this.props.message.created_at).fromNow()}</small>
                        <br/>
                        <b>{(!this.state.read) ? mark_as_read : ''}</b>
                    </div>
                </div>
            </div>
        )
    }
}