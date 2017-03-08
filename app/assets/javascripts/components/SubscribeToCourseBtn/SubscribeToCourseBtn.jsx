class SubscribeToCourseBtn extends React.Component {
    constructor(props) {
        super(props);
        this.state = {subscribed: false};
        this.subscribe = this.subscribe.bind(this);
        this.unsubscribe = this.unsubscribe.bind(this);
    }

    componentDidMount() {
        this.setState({subscribed: this.props.subscribed});
    }

    subscribe() {
        let ajax = $.post(`/subscriptions`, {
            id: this.props.course_id
        });

        ajax.done(() => {
            this.setState({subscribed: true});
        })
    }

    unsubscribe() {
        let ajax = $.ajax({
           url: `/subscriptions/${this.props.course_id}`,
           method: 'DELETE',
           DataType: 'json'
        });

        ajax.done(() => {
            this.setState({subscribed: false});
        })
    }

    render() {
        let subscribe_to_course_btn = (
            <button className="btn btn-primary" data-toggle="tooltip" onClick={this.subscribe} data-placement="right"
                    title="You will get notifications and emails about new lessons while subscribed">
                <i className="fa fa-star" aria-hidden="true"/> Subscribe
            </button>
        );

        let unsubscribe_from_course_btn = (
            <button className="btn btn-secondary" data-toggle="tooltip" onClick={this.unsubscribe}>
                <i className="fa fa-window-close" aria-hidden="true"/> Unsubscribe
            </button>
        );

        if (!this.state.subscribed)
            return subscribe_to_course_btn;
        else
            return unsubscribe_from_course_btn;
    }


}

SubscribeToCourseBtn.PropTypes = {
    course_id: React.PropTypes.number,
    subscribed: React.PropTypes.bool,
    subscribers_count: React.PropTypes.number
};