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
            <a href='#' className="card-link text-danger" onClick={this.unsubscribe}>Unsubscribe</a>
        );

        return (

            <div className="card animated fadeIn" style={{margin: '5px'}}>
                <div className="card-block">
                    <h4 className="card-title">{this.props.subscription.title}</h4>
                    <p className="card-text">
                        {this.props.subscription.description}
                    </p>
                    <a href={`/courses/${this.props.subscription.slug}`} className="card-link">Visit</a>
                    {this.belongsToUser() ? unsubscribe_button : null}
                </div>
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