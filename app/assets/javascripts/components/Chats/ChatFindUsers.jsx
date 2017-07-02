class ChatFindUsers extends React.Component {
    constructor(props) {
        super(props);
        this.state = {users: [], username: '', loading: false};
        this.findUser = _.debounce(this.findUser.bind(this), 500);
    }

    componentDidMount() {
        $(document).unbind('chat:hide_found_users').on('chat:hide_found_users', () => {
           this.setState({users: [], username: ''});
            this.textInput.value = ''
        });
    }

    changeUsername() {
        if (!this.textInput.value)
            this.setState({users: []});

        this.setState({username: this.textInput.value});
        this.findUser();
    }

    findUser() {

        if (this.state.username.length) {
            console.log('find');
            this.setState({loading: true});

            let ajax = $.post('/api/v1/users/find_by_username', {username: this.state.username});
            ajax.done((users) => {
                this.setState({users: users})
            }).always(() => {
                this.setState({loading: false});
            });
        }
    }

    render() {
        let fa_cog = (
            <div className="text-xs-center">
                <i className="fa fa-cog fa-spin fa-3x fa-fw"/>
                <span className="sr-only">Loading...</span>
            </div>
        );
        let foundUsersList = (this.state.loading) ? fa_cog : (this.state.users.length) ?
                <ChatFoundUsersList users={this.state.users}/> : '';

        return (
            <div>
                <div className="form-group row">
                    <div className="col-md-12">
                        <input type="text" className="form-control form-control-lg" id="smFormGroupInput"
                               placeholder="Username..." ref={(input) => { this.textInput = input; }}
                               onChange={this.changeUsername.bind(this)}/>
                    </div>
                </div>
                {foundUsersList}
            </div>
        )
    }


}