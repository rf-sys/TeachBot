class ChatMessage extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <div className="media animated">
                <img className="d-flex mr-2 chat_user_avatar" src={this.props.message.user.avatar}
                     alt="Not found"/>
                <div className="media-body">
                    <h4 className="mt-0">{this.props.message.user.username}</h4>
                    {this.props.message.text}<br/>
                    <div>
                        <small>{moment(this.props.message.created_at).fromNow()}</small>
                    </div>
                </div>
            </div>
        )
    }
}