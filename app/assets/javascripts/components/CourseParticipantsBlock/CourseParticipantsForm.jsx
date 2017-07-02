class CourseParticipantsForm extends React.Component {
    constructor(props) {
        super(props);
    }

    unsubscribe(user) {
        this.props.unsubscribe(user);
    }

    setParticipant(user) {
        this.props.setParticipant(user);
    }

    render() {

        return (
            <div className="modal fade" id="subscribe_modal">
                <div className="modal-dialog" role="document">
                    <div className="modal-content">
                        <div className="modal-header">
                            <h4 className="modal-title">Edit participants</h4>
                            <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div className="modal-body">
                            <FormCourseParticipants participants={this.props.participants} course={this.props.course}
                                             unsubscribe={this.unsubscribe.bind(this)}
                                             setParticipant={this.setParticipant.bind(this)}
                            />
                        </div>
                        <div className="modal-footer">
                            <button type="button" className="btn btn-secondary" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}