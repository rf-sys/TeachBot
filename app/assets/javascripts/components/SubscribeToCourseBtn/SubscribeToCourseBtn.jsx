class SubscribeToCourseBtn extends React.Component {
    constructor(props) {
        super(props);
        this.state = {subscribed: false, loading: false};
        this.subscribe = this.subscribe.bind(this);
        this.unsubscribe = this.unsubscribe.bind(this);
    }

    componentDidMount() {
        this.setState({subscribed: this.props.subscribed});
    }

    subscribe() {
        this.setState({loading: true});

        $('#subscribe_to_course_btn').tooltip('hide');

        let ajax = $.post(`/subscriptions`, {
            id: this.props.course_id
        });

        ajax.done(() => {
            this.setState({subscribed: true});
            $(document).trigger('course:add_subscriber');
        });

        ajax.always(() => {
            this.setState({loading: false});
            $('#subscribe_to_course_btn').tooltip();
        });
    }

    unsubscribe() {
        this.setState({loading: true});

        let ajax = $.ajax({
            url: `/subscriptions/${this.props.course_id}`,
            method: 'DELETE',
            DataType: 'json'
        });

        ajax.done(() => {
            this.setState({subscribed: false});
            $(document).trigger('course:remove_subscriber');
        });

        ajax.always(() => {
            this.setState({loading: false});
            $('#subscribe_to_course_btn').tooltip();
        });
    }

    render() {
        let subscribe_to_course_btn = (
            <button className="btn btn-primary" onClick={this.subscribe} id="subscribe_to_course_btn"
                    data-toggle="tooltip" data-placement="right"
                    title="You will get notifications and emails about new lessons while subscribed"
                    disabled={this.state.loading}>
                <i className="fa fa-star" aria-hidden="true"/> Subscribe
            </button>
        );

        let unsubscribe_from_course_btn = (
            <button className="btn btn-secondary" onClick={this.unsubscribe} id="subscribe_to_course_btn"
                    disabled={this.state.loading}>
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