class ChatParticipant extends React.Component {
    constructor(props) {
        super(props)
    }

    render() {
        return (
            <a href={ '/users/' + this.props.user.id } className="list-group-item list-group-item-action">
                <div className="row flex-items-xs-middle">
                    <div className="col-lg-3 text-xs-center">
                        <img src={this.props.user.avatar} className="chat_user_avatar"/>
                    </div>
                    <div className="col-lg-9 word_wrap_bw text-xs-center">{this.props.user.username}</div>
                </div>
            </a>
        )
    }
}