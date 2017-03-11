class GlobalSearchUsers extends React.Component {
    constructor(props) {
        super(props);
    }

    renderUsers() {
        let users = this.props.users;

        return users.map((user) => {
            return <GlobalSearchUser key={user.id} user={user}/>
        });
    }

    render() {
        return (
            <div>
                <div className="bg-primary text-white list-group-item round-0">
                    Users
                </div>
                <div className="list-group">
                    {this.props.users.length ? this.renderUsers() : null}
                </div>
            </div>
        )
    }
}

GlobalSearchUsers.propTypes = {
    users: React.PropTypes.array
};