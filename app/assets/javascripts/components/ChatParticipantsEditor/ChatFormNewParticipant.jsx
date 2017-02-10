class ChatFormNewParticipant extends React.Component {
    constructor(props) {
        super(props);
        this.state = {users: [], username: '', loading: false};
        this.findUser = _.debounce(this.findUser.bind(this), 500);
        this.addParticipant = this.addParticipant.bind(this);
    }

    changeUsername(event) {
        this.setState({username: event.target.value});
        this.findUser();
    }

    findUser() {
        if (this.state.username.length) {
            this.setState({loading: true});

            let ajax = $.post('/api/v1/users/find_by_username', {username: this.state.username});
            ajax.done((users) => {
                this.setState({users: users})
            }).always(() => {
                this.setState({loading: false});
            });
        }
    }

    addParticipant(user) {
        let ajax = $.post(`/chats/${this.props.chat}/add_participant`, {user_id: user.id});
        ajax.done(() => {
            let users = this.state.users.slice();
            users.filter((old_user) => old_user.id != user.id);
            this.setState({users: users});
            this.props.addParticipant(user);
        });

        /*
         let ajax = $.post(`/courses/${this.props.course}/subscribers`, {id: user.id});

         ajax.done((response) => {
         this.props.setSubscriber(response.user, response.status);
         }).always(() => {
         this.setState({loading: false});
         });
         */
    }

    render() {

        let usersList = this.state.users.map((user) => {
            let no_participant = false;

            this.props.participants.map((participant) => {
                if (user.id == participant.id) {
                    no_participant = true;
                }
            });

            if (!no_participant) {
                return <ChatFormFoundUser user={user} key={user.id} addParticipant={this.addParticipant}/>
            }
        });

        let spinner = (
            <div className="text-xs-center">
                <i className="fa fa-spinner fa-spin fa-3x fa-fw"/>
                <span className="sr-only">Loading...</span>
            </div>
        );

        let table = (
            <div>
                <table className="table">
                    <thead>
                    <tr>
                        <th>Avatar</th>
                        <th>Username</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    {usersList}
                    </tbody>
                </table>
            </div>
        );

        return (
            <div>
                <div className="form-group">
                    <label htmlFor="new_subscriber_username">Type user's username:</label>
                    <input className="form-control" placeholder="User's username" type="text"
                           id="new_subscriber_username" value={this.state.username}
                           onChange={this.changeUsername.bind(this)} required/>
                </div>
                {(this.state.users.length) ? table : (this.state.loading) ? spinner : ''}
            </div>
        )
    }
}