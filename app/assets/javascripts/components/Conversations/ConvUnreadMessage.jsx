class ConvUnreadMessage extends React.Component {
    constructor(props) {
        super(props);
    }

    markMessageAsRead() {
        $.post(`/messages/${this.props.message.id}/read`);
    }

    render() {
        return (
            <div className="media" style={{position: 'relative'}}>

                <button type="button" onClick={this.markMessageAsRead.bind(this)}
                        className="btn btn-sm btn-danger rounded-circle unread_messages_mark_as_read_button">
                    <i className="fa fa-trash-o" aria-hidden="true"/>
                </button>
                <a className="media-left" href="#">
                    <img className="media-object chat_user_avatar" src={this.props.message.user.avatar}
                         alt="Not found"/>
                </a>
                <div className="media-body">
                    <h4 className="media-heading">{this.props.message.user.username}</h4>
                    {this.props.message.text}<br/>
                    <div>
                        <small>{moment(this.props.message.created_at).fromNow()}</small>
                        <br/>
                    </div>
                </div>
            </div>
        )
    }
}