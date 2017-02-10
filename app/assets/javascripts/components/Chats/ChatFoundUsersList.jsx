class ChatFoundUsersList extends React.Component {
    constructor(props) {
        super(props)
    }

    render() {
        let users = this.props.users.map((user, i) => {
            return <ChatFoundUser user={user} key={user.id} id={i + 1}/>
        });

        return (
            <table className="table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Avatar</th>
                    <th>Username</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                {users}
                </tbody>
            </table>
        )

    }
}