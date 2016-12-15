class Form extends React.Component {
    constructor(props) {
        super(props);
        this.state = {message: null, message_show: false, message_type: true};
        this.hideMessage = this.hideMessage.bind(this);
    }

    unsubscribe(user, status = null) {
        this.props.unsubscribe(user);

        if (status) this.setMessage(status);
    }

    setSubscriber(user, status = null) {
        this.props.setSubscriber(user);

        if (status) this.setMessage(status);
    }

    hideMessage() {
        this.setState({message_show: false, message_type: true});
    }

    setMessage(message, type = true) {
        this.hideMessage();
        setTimeout(() => {
            this.setState({message: message, message_show: true, message_type: type});
        }, 500);
    }

    render() {
        let messageClass = (this.state.message_type) ? 'alert alert-success' : 'alert alert-danger';

        let messageBox = (
            <div className={messageClass}>
                <button type="button" className="close" onClick={this.hideMessage}>
                    <span aria-hidden="true">&times;</span>
                </button>
                {this.state.message}
            </div>

        );
        return (
            <div className="modal fade" id="subscribe_modal">
                <div className="modal-dialog" role="document">
                    <div className="modal-content">
                        <div className="modal-header">
                            <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                            <h4 className="modal-title">Edit subscribers</h4>
                        </div>
                        <div className="modal-body">
                            <ReactCSSTransitionGroup
                                transitionName="fade"
                                transitionEnterTimeout={500}
                                transitionLeaveTimeout={300}>
                                {(this.state.message_show) ? messageBox : ''}
                            </ReactCSSTransitionGroup>
                            <FormSubscribers subscribers={this.props.subscribers} course={this.props.course}
                                             unsubscribe={this.unsubscribe.bind(this)}
                                             setSubscriber={this.setSubscriber.bind(this)}
                                             setMessage={this.setMessage.bind(this)}/>
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