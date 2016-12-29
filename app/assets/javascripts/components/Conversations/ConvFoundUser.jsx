class ConvFoundUser extends React.Component {
    constructor(props) {
        super(props)
    }

    showNewMessageModal() {
        $(document).trigger('modalNewMessage', this.props.user);
        $('#modalNewMessage').modal('toggle');
    }

    render() {
        return (
            <tr>
                <th scope="row">{this.props.id}</th>
                <td>
                    <img src={this.props.user.avatar} className="chat_user_avatar" alt="Not found"/>
                </td>
                <td>{this.props.user.username}</td>
                <td>
                    <button className="btn btn-outline-primary" onClick={this.showNewMessageModal.bind(this)}>Send message</button>
                </td>
            </tr>
        )
    }
}