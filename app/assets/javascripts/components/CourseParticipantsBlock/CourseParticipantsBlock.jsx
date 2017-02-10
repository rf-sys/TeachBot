class CourseParticipantsBlock extends React.Component {
    constructor(props) {
        super(props);
        this.state = {participants: [], error: null};
        this.loadParticipants = this.loadParticipants.bind(this);
    }

    componentDidMount() {
        this.loadParticipants();
    }

    loadParticipants() {
        let ajax = $.get(`/courses/${this.props.course}/participants`);
        ajax.done(({participants}) => {
            this.setState({participants: participants})
        }).fail((response) => {
            this.setState({error: response.responseJSON.status});
        });
    }

    unsubscribe(user) {
        let participants = this.state.participants.filter((participant) => participant.id != user.id);
        this.setState({participants: participants});
    }

    setParticipant(user) {
        let participants = this.state.participants.slice();
        participants.push(user);
        this.setState({participants: participants});
    }

    render() {
        let form = (
            <div>
                <button className="btn btn-outline-info btn-block" data-toggle="modal" data-target="#subscribe_modal">
                    Edit participants
                </button>
                <CourseParticipantsForm participants={this.state.participants} course={this.props.course}
                      unsubscribe={this.unsubscribe.bind(this)} setParticipant={this.setParticipant.bind(this)}/>
            </div>
        );
        return (
            <div>
                <CourseParticipants participants={this.state.participants}/>
                { (this.props.current_user == this.props.author) ? form : '' }
            </div>

        )
    }
}