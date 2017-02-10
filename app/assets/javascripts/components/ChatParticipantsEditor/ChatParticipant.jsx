class ChatParticipant extends React.Component {
    constructor(props) {
        super(props);

        this.kick = this.kick.bind(this);
    }

    kick() {
        this.props.kick(this.props.user);
    }

    render() {
        return (
            <tr>
                <td>
                    <img src={this.props.user.avatar} className="chat_user_avatar" alt="Not found"/>
                </td>
                <td>{this.props.user.username}</td>
                <td>
                    <button className="btn btn-outline-danger"
                    onClick={this.kick}>Kick from dialog</button>
                </td>
            </tr>
        )
    }
}