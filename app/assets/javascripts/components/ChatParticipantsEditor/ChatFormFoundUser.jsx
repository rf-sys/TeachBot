class ChatFormFoundUser extends React.Component {
    constructor(props) {
        super(props);
        this.addParticipant = this.addParticipant.bind(this);
    }

    addParticipant() {
        this.props.addParticipant(this.props.user);
    }

    render() {
        return (
            <tr>
                <td>
                    <img src={this.props.user.avatar} className="course-subscriber-avatar"/>
                </td>
                <td>{this.props.user.username}</td>
                <td>
                   <button className="btn btn-outline-info" onClick={this.addParticipant}>Add to dialog</button>
                </td>
            </tr>
        )
    }
}