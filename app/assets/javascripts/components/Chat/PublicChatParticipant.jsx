class PublicChatParticipant extends React.Component {
    constructor(props) {
        super(props)
    }

    render() {
        return (
            <a href={ '/users/' + this.props.user.slug } className="list-group-item list-group-item-action">
                <div className="row flex-items-xs-middle">
                    <div className="col text-center">
                        <img src={this.props.user.avatar} className="chat_user_avatar"/>
                    </div>
                    <div className="col word_wrap_bw text-center">{this.props.user.username}</div>
                </div>
            </a>
        )
    }
}