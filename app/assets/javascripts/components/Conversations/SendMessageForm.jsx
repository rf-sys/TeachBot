class SendMessageForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {message: ''};
    }

    send(e) {
        e.preventDefault();
        this.props.sendMessage(this.state.message);
        this.setState({message: ''});
    }

    changeTextarea(e) {
        this.setState({message: e.target.value});
    }

    render() {
        return (
            <form role="form" onSubmit={this.send.bind(this)}>
                <div className="form-group">
                    <textarea className="form-control" placeholder="Message text" required
                              onChange={this.changeTextarea.bind(this)} value={this.state.message}/>
                </div>
                <div className="text-xs-right">
                    <button className="btn btn-outline-success">Send Message</button>
                </div>
            </form>
        )
    }
}