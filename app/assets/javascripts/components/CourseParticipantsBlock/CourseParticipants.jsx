class CourseParticipants extends React.Component {
    constructor(props) {
        super(props)
    }

    render() {
        let participants = this.props.participants.map((participant, i) => {
            return <CourseParticipant participant={participant} key={i}/>
        });
        return (
            <div>
                <h2 className="text-xs-center">Participants</h2>
                <div className="list-group">
                    {participants}
                </div>
            </div>

        )
    }
}