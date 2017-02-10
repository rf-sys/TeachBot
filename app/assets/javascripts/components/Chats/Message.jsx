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
        let ajax = $.post(`/messages/${this.props.message.id}/read`);

        ajax.done((resp) => {
            this.setState({read: true});
        });

    }


    render() {
        let mark_as_read = (
            <button className="btn btn-sm btn-outline-info" onClick={this.markMessageAsRead}>Mark as read</button>
        );
        return (
            <div className="media animated">
                <img className="d-flex mr-2 chat_user_avatar" src={this.props.message.user.avatar}
                     alt="Not found"/>
                <div className="media-body">
                    <h4 className="mt-0">{this.props.message.user.username}</h4>
                    {this.props.message.text}<br/>
                    <div>
                        <small>{moment(this.props.message.created_at).fromNow()}</small>
                        <br/>
                        <b>{(!this.state.read) ? mark_as_read : ''}</b>
                    </div>
                </div>
            </div>
        )
    }
}