class FormSubscribers extends React.Component {
    constructor(props) {
        super(props);
        this.state = {form_new_subscriber_show: false};
    }

    unsubscribe(user, status = null) {
        this.props.unsubscribe(user, status);
    }

    setSubscriber(user, status = null) {
        this.props.setSubscriber(user, status);

        // if (status) this.setState({message: status, message_show: true})
    }

    setMessage(message, type) {
        this.props.setMessage(message, type);
    }

    changeNewFormSubscriberState() {
        this.setState({form_new_subscriber_show: !this.state.form_new_subscriber_show});
    }

    render() {
        let subscribers = this.props.subscribers.map((subscriber, key) => {
            return <FormSubscriber key={key} subscriber={subscriber} course={this.props.course}
                                   unsubscribe={this.unsubscribe.bind(this)}
                                   setMessage={this.setMessage.bind(this)}/>
        });
        let NewSubscriberForm = <FormNewSubscriber subscribers={this.props.subscribers}
                                                   course={this.props.course}
                                                   setSubscriber={this.setSubscriber.bind(this)}
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
                        {subscribers}
                    </ReactCSSTransitionGroup>
                </table>
                {(this.state.form_new_subscriber_show) ? NewSubscriberForm : ''}
                <button className="btn btn-outline-info btn-block"
                        onClick={this.changeNewFormSubscriberState.bind(this)}>
                    Add new subscriber
                </button>
            </div>
        )
    }
}