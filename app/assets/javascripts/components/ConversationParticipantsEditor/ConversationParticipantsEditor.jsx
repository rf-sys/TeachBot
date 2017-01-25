class ConversationParticipantsEditor extends React.Component {
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
                <ConversationParticipants users={this.props.users} kick={this.kick}/>
                <ConversationFormNewParticipant participants={this.props.users} conversation={this.props.conversation}
                                                addParticipant={this.addParticipant}/>
            </div>
        )
    }
}