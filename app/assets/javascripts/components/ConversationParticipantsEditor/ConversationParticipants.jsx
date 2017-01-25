class ConversationParticipants extends React.Component {
    constructor(props) {
        super(props);
        this.kick = this.kick.bind(this);
    }

    kick(user) {
        this.props.kick(user);
    }

    render() {
        let list = this.props.users.map((user, i) => {
            return <ConversationParticipant user={user} iterator={i} key={user.id} kick={this.kick}/>
        });
        return (
            <table className="table">
                <thead>
                <tr>
                    <th>Avatar</th>
                    <th>Username</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                {list}
                </tbody>
            </table>
        )
    }
}