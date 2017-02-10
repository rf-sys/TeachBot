class CourseParticipantsUser extends React.Component {
    constructor(props) {
        super(props)
    }

    subscribe() {
        this.props.makeParticipant(this.props.user);
    }

    render() {
        let subscribeBtn = (
            <button className="btn btn-outline-primary" onClick={this.subscribe.bind(this)}>
                Subscribe
            </button>
        );
        return (
            <tr>
                <td>
                    <img src={this.props.user.avatar} className="course-subscriber-avatar"/>
                </td>
                <td>{this.props.user.username}</td>
                <td>
                    {(this.props.subscribed) ? <b>Already subscribed</b> : subscribeBtn}
                </td>
            </tr>
        )
    }
}