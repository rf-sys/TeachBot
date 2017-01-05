class ConvUnreadMessage extends React.Component {
    constructor(props) {
        super(props);
    }

    markMessageAsRead() {
        let ajax = $.post(`/api/messages/read`, {id: this.props.message.id});

        ajax.done(
            /** @param {{status: String}} resp */
            (resp) => {
            this.setState({read: true});
            this.props.removeMessage(this.props.message.id);
        });

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
                        <small>{momentJs(this.props.message.created_at).fromNow()}</small>
                        <br/>
                    </div>
                </div>
            </div>
        )
    }
}