class PublicChatParticipants extends React.Component {
    constructor(props) {
        super(props);
        this.state = {participants: []}
    }

    componentDidMount() {
        $(document).unbind('participants').on('participants', (event, {members}) => {
            this.setState({participants: members});
        });
    }

    render() {
        let participants = this.state.participants.map((participant) => {
            return <PublicChatParticipant user={participant} key={participant.id}/>
        });
        return (
            <div className="list-group">
                <ReactCSSTransitionGroup transitionName="fade"
                                         transitionEnterTimeout={500}
                                         transitionLeaveTimeout={300}>
                    {participants}
                </ReactCSSTransitionGroup>
            </div>
        )
    }
}