class ChatMessage extends React.Component {
    constructor(props) {
        super(props);
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
                    </div>
                </div>
            </div>
        )
    }
}