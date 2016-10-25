class UsernameField extends React.Component {
    constructor(props) {
        super(props);

        this.props = props;

        this.state = {username: props.username}
    }

    changeUsername(e) {

        this.setState({username: e.target.value});

        this.props.changeUsername(e.target.value);

    }

    render() {
        return (
            <div className="form-group">
                <label htmlFor="profile_username" className="form-control-label">Username:</label>
                <input type="text" className="form-control" id="profile_username"
                       value={this.state.username} onChange={this.changeUsername.bind(this)}
                       required="true" placeholder="Type your new username" />
            </div>
        )
    }
}

export default UsernameField