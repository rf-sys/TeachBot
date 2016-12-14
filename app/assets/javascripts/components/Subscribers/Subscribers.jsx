class Subscribers extends React.Component {
    constructor(props) {
        super(props);
        this.state = {subscribers: [], subscriber_form: false, message: null, message_show: false};
        this.setMessage = this.setMessage.bind(this);
    }

    componentDidMount() {
        this.getSubscribers();
    }

    getSubscribers() {
        let ajax = jQuery.post('/api/subscribers', {id: this.props.course});
        ajax
            .done(({subscribers}) => {
                this.setState({subscribers: subscribers})
            })
            .fail((response) => {
                this.setMessage(response.responseJSON.status);
            });
    }

    changeNewSubscriberFormState() {

        this.setState({subscriber_form: !this.state.subscriber_form})
    }

    setSubscriber(user, status = null) {
        let subscribers = this.state.subscribers.slice();
        subscribers.push(user);
        this.setState({subscribers: subscribers});

        if (status) this.setState({message: status, message_show: true})
    }

    unsubscribe(user, status = null) {
        let subscribers = this.state.subscribers.filter((subscriber) => subscriber.id != user.id);
        this.setState({subscribers: subscribers});

        if (status) this.setState({message: status, message_show: true})
    }

    hideMessage() {
        this.setState({message_show: false});
    }

    setMessage(status) {
        this.setState({message: status, message_show: true})
    }

    render() {
        let subscribers = this.state.subscribers.map((subscriber, key) => {
            return <Subscriber key={key} subscriber={subscriber} course={this.props.course}
                               unsubscribe={this.unsubscribe.bind(this)} setMessage={this.setMessage}/>
        });
        let NewSubscriberForm = <NewSubscriber subscribers={this.state.subscribers}
                                               course={this.props.course} setSubscriber={this.setSubscriber.bind(this)}
                                               setMessage={this.setMessage}/>;
        return (
            <div>
                <Message message={this.state.message} hideMessage={this.hideMessage.bind(this)}
                         show={this.state.message_show}/>
                <table className="table">
                    <thead>
                    <tr>
                        <th>Avatar</th>
                        <th>Username</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    {subscribers}
                    </tbody>
                </table>
                {(this.state.subscriber_form) ? NewSubscriberForm : ''}
                <button className="btn btn-outline-info btn-block"
                        onClick={this.changeNewSubscriberFormState.bind(this)}>Add new subscriber
                </button>
            </div>
        )
    }
}