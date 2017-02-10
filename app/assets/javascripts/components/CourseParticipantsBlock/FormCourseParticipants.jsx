class FormCourseParticipants extends React.Component {
    constructor(props) {
        super(props);
        this.state = {form_new_participant_show: false};
    }

    unsubscribe(user) {
        this.props.unsubscribe(user);
    }

    setParticipant(user) {
        this.props.setParticipant(user);

        // if (status) this.setState({message: status, message_show: true})
    }

    setMessage(message, type) {
        this.props.setMessage(message, type);
    }

    changeFormNewCourseParticipantState() {
        this.setState({form_new_participant_show: !this.state.form_new_participant_show});
    }

    render() {
        let participants = this.props.participants.map((participant, key) => {
            return <FormCourseParticipant key={key} participant={participant} course={this.props.course}
                                          unsubscribe={this.unsubscribe.bind(this)}
                                          setMessage={this.setMessage.bind(this)}/>
        });
        let NewSubscriberForm = <FormNewCourseParticipant participants={this.props.participants}
                                                          course={this.props.course}
                                                          setParticipant={this.setParticipant.bind(this)}
        />;
        return (
            <div>
                <table className="table">
                    <thead>
                    <tr>
                        <th>Avatar</th>
                        <th>Username</th>
                        <th></th>
                    </tr>
                    </thead>
                    <ReactCSSTransitionGroup component="tbody"
                                             transitionName="fade"
                                             transitionEnterTimeout={500}
                                             transitionLeaveTimeout={300}>
                        {participants}
                    </ReactCSSTransitionGroup>
                </table>
                {(this.state.form_new_participant_show) ? NewSubscriberForm : ''}
                <button className="btn btn-outline-info btn-block"
                        onClick={this.changeFormNewCourseParticipantState.bind(this)}>
                    Add new subscriber
                </button>
            </div>
        )
    }
}