class Subscriptions extends React.Component {
    constructor(props) {
        super(props);
        this.state = {subscriptions: [], current_page: 0, total_pages: 1, loading: true};
        this.getSubscriptions = this.getSubscriptions.bind(this);
        this.unsubscribe = this.unsubscribe.bind(this);
        this.renderSubscriptions = this.renderSubscriptions.bind(this);
    }

    componentDidMount() {
        this.getSubscriptions();
    }

    unsubscribe(subscription_id) {
        let ajax = $.ajax({
            url: `/users/${this.props.user}/subscriptions/${subscription_id}`,
            method: 'DELETE',
            dataType: 'json'
        });

        ajax.done(() => {
            // it helps us to regenerate not only list of subscriptions but pages either
            this.getSubscriptions();
        });
    }

    getSubscriptions(page = 1) {
        let ajax = $.getJSON(`/users/${this.props.user}/subscriptions?page=${page}`);

        ajax.done((response) => {
            this.setState({
                subscriptions: response.subscriptions,
                current_page: response.current_page,
                total_pages: response.total_pages,
                loading: false
            });
        })
    }

    renderSubscriptions() {
        let subscriptions_chunk = _.chunk(this.state.subscriptions, 2);


        return subscriptions_chunk.map((chunk, i) => {
            return (
                <div className="card-deck" key={i}>
                    {chunk.map((subscription) => {
                        return <Subscription subscription={subscription} key={subscription.id}
                                             user={this.props.user} current_user={this.props.current_user}
                                             unsubscribe={this.unsubscribe}/>
                    })}
                </div>
            )
        });
    }

    render() {
        let not_found = (
            <div className="text-center">
                <h2>Subscriptions not found</h2>
            </div>
        );

        let loading = (
            <div className="text-center">
                <i className="fa fa-spinner fa-spin fa-3x fa-fw"/>
                <span className="sr-only">Loading...</span>
            </div>
        );

        let content = (
            <div>
                {!_.isEmpty(this.state.subscriptions) ? this.renderSubscriptions() : not_found}
                <Paginator current_page={this.state.current_page}
                           total_pages={this.state.total_pages}
                           action={this.getSubscriptions}
                />
            </div>
        );
        return (
            <div>
                {this.state.loading ? loading : content}
            </div>
        )
    }
}

Subscriptions.propTypes = {
    user: React.PropTypes.number, // target user id
    current_user: React.PropTypes.number // auth user id
};