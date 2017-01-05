class UnreadMessage extends React.Component {
    constructor(props) {
        super(props);
    }

    markMessageAsRead() {
        let ajax = $.post(`/api/messages/read`, {id: this.props.message.id});

        ajax.done((resp) => {
            this.setState({read: true});
        });

    }


    render() {
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
                        <button className="btn btn-sm btn-outline-info" onClick={this.markMessageAsRead}>Mark as read</button>
                    </div>
                </div>
            </div>
        )
    }
}