class NewSubscriber extends React.Component {
    constructor(props) {
        super(props);
        this.state = {subscribers: this.props.subscribers, users: [], username: ''};
        this.findUser = _.debounce(this.findUser.bind(this), 1000);
        this.subscribeUser = this.subscribeUser.bind(this);
    }

    changeUsername(event) {
        this.setState({username: event.target.value});
        this.findUser();
    }

    findUser() {
        if (this.state.username.length) {
            let ajax = $.get('/api/find/user/username', {username: this.state.username});
            ajax.done(({users}) => {
                this.setState({users: users})
            })
        }
    }

    subscribeUser(user) {
        let ajax = $.post(`/courses/${this.props.course}/subscribers`, {id: user.id});

        ajax.done((response) => {
            this.props.setSubscriber(response.user, response.status);
        });
        ajax.fail((response) => {
            this.props.setMessage(response.responseJSON.status);
        })
    }

    render() {


        let usersList = this.state.users.map((user, key) => {

            let exist = false;
            this.state.subscribers.map((subscriber) => {
                if (user.id == subscriber.id) exist = true;
            });

            return <User user={user} key={key} subscribed={exist}
                         subscribeUser={this.subscribeUser}
            />;
        });

        return (
            <div>
                <form>
                    <div className="form-group">
                        <label htmlFor="new_subscriber_username">Type user's username:</label>
                        <input className="form-control" placeholder="User's username" type="text"
                               id="new_subscriber_username" value={this.state.username}
                               onChange={this.changeUsername.bind(this)} required
                               ref={(input) => {
                                   this.textInput = input;
                               }}
                        />
                    </div>
                </form>
                <div>
                    <table className="table">
                        <thead>
                        <tr>
                            <th>Avatar</th>
                            <th>Username</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody>
                        {usersList}
                        </tbody>
                    </table>
                </div>
            </div>
        )
    }
}