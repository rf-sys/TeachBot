class CourseParticipant extends React.Component {
    constructor(props) {
        super(props)
    }

    render() {
        let url = '/users/' + this.props.participant.slug;

        return (
            <a href={url} className="list-group-item list-group-item-action">
                <div className="row justify-content-around">
                    <div className="col-3">
                        <img src={this.props.participant.avatar} className="course-subscriber-avatar rounded-circle"/>
                    </div>
                    <div className="col-9 align-self-center text-center">
                        {this.props.participant.username}
                    </div>
                </div>
            </a>
        )
    }
}