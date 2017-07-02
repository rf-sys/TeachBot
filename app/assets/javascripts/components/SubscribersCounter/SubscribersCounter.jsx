class SubscribersCounter extends React.Component {
    constructor(props) {
        super(props);
        this.state = {subscribers_count: 0};
        this.addSubscriber = this.addSubscriber.bind(this);
        this.removeSubscriber = this.removeSubscriber.bind(this);
    }

    componentDidMount() {
        this.setState({subscribers_count: this.props.subscribers_count});

        $(document)
            .on('course:add_subscriber', () => this.addSubscriber())
            .on('course:remove_subscriber', () => this.removeSubscriber());
    }

    addSubscriber() {
        let current_subscribers_count = this.state.subscribers_count;
        this.setState({subscribers_count: current_subscribers_count + 1});
    }

    removeSubscriber() {
        let current_subscribers_count = this.state.subscribers_count;
        this.setState({subscribers_count: current_subscribers_count - 1});
    }

    render() {
        return <b>{this.state.subscribers_count}</b>;
    }
}

SubscribersCounter.PropTypes = {
    subscribers_count: React.PropTypes.number
};