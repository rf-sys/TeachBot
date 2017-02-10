class Subscription extends React.Component {
    constructor(props) {
        super(props);
        this.unsubscribe = this.unsubscribe.bind(this);
    }

    unsubscribe(e) {
        e.preventDefault();
        this.props.unsubscribe(this.props.subscription.id);
    }

    belongsToUser() {
        return this.props.current_user && this.props.current_user == this.props.user;
    }


    render() {
        let unsubscribe_button = (
            <button className="btn btn-sm btn-outline-danger" onClick={this.unsubscribe}>
                Unsubscribe
            </button>
        );

        return (
            <div className="list-group-item list-group-item-action flex-column align-items-start">
                <div className="d-flex w-100 justify-content-between">
                    <h5 className="mb-1">{this.props.subscription.title}</h5>
                    <small>
                        <a href={`/courses/${this.props.subscription.slug}`} className="btn btn-sm btn-outline-info">
                            Visit course
                        </a>
                        {this.belongsToUser() ? unsubscribe_button : null}
                    </small>
                </div>

                <p className="mb-1">
                    {this.props.subscription.description}
                </p>
            </div>
        )
    }
}

Subscription.propTypes = {
    subscription: React.PropTypes.object, // subscription == course
    user: React.PropTypes.number, // target user id
    current_user: React.PropTypes.number, // auth user id
    unsubscribe: React.PropTypes.func // parent unsubscribe method
};