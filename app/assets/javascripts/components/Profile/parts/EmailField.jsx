class EmailField extends React.Component {
    constructor(props) {
        super(props);

        this.props = props;

        this.state = {email: props.email}
    }

    changeEmail(e) {

        this.setState({email: e.target.value});

        this.props.changeEmail(e.target.value);

    }

    render() {
        return (
            <div className="form-group">
                <label htmlFor="profile_email" className="form-control-label">Email:</label>
                <input type="email" className="form-control" id="profile_email"
                       value={this.state.email} onChange={this.changeEmail.bind(this)}
                       required="true" placeholder="Type your new email"/>
            </div>
        )
    }
}

export default EmailField