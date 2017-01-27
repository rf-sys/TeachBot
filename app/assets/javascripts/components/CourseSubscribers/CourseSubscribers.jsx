class CourseSubscribers extends React.Component {
    constructor(props) {
        super(props);
        this.state = {subscribers: [], error: null};
        this.loadSubscribers = this.loadSubscribers.bind(this);
    }

    componentDidMount() {
        this.loadSubscribers();
    }

    loadSubscribers() {
        let ajax = $.get(`/courses/${this.props.course}/subscribers`);
        ajax.done(({subscribers}) => {
            this.setState({subscribers: subscribers})
        }).fail((response) => {
            this.setState({error: response.responseJSON.status});
        });
    }

    unsubscribe(user) {
        let subscribers = this.state.subscribers.filter((subscriber) => subscriber.id != user.id);
        this.setState({subscribers: subscribers});
    }

    setSubscriber(user) {
        let subscribers = this.state.subscribers.slice();
        subscribers.push(user);
        this.setState({subscribers: subscribers});
    }

    render() {
        let form = (
            <div>
                <button className="btn btn-outline-info btn-block" data-toggle="modal" data-target="#subscribe_modal">
                    Edit subscribers
                </button>
                <Form subscribers={this.state.subscribers} course={this.props.course}
                      unsubscribe={this.unsubscribe.bind(this)} setSubscriber={this.setSubscriber.bind(this)}/>
            </div>
        );
        return (
            <div>
                <WrapperList subscribers={this.state.subscribers}/>
                { (this.props.current_user == this.props.author) ? form : '' }
            </div>

        )
    }
}


CourseSubscribers.defaultProps = {
    subscribers: []
};