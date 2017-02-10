class ChatParticipantsEditor extends React.Component {
    constructor(props) {
        super(props);
        this.addParticipant = this.addParticipant.bind(this);
        this.kick = this.kick.bind(this);
    }

    addParticipant(user) {
        this.props.addParticipant(user);
    }

    kick(user) {
        this.props.kick(user);
    }

    render() {
        return (
            <div>
                <ChatParticipants users={this.props.users} kick={this.kick}/>
                <ChatFormNewParticipant participants={this.props.users} chat={this.props.chat}
                                                addParticipant={this.addParticipant}/>
            </div>
        )
    }
}