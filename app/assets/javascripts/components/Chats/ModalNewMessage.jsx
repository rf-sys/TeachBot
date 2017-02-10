class ModalNewMessage extends React.Component {
    constructor(props) {
        super(props);
        this.state = {message: '', user: {}, error_message: {errors: [], status: '', show: false}};
    }

    componentDidMount() {
        $(document).on('modalNewMessage', function (event, user) {
            this.setState({user: user});
        }.bind(this))
    }

    prepareMessage() {
        if (this.state.message.length) {
            this.send();
        }
    }

    send() {
        let ajax = $.post('/messages', {user_id: this.state.user.id, message: {text: this.state.message}});
        ajax.done((resp) => {
            if (resp.type == 'new_message') {
                $('#modalNewMessage').modal('hide');
                $(`#collapse_${resp.response.chat_id}_chat`).collapse('show');
            }

            if (resp.type == 'new_chat')
                $(document).trigger('chat:new_chat', resp.chat);

            this.setState({message: ''});
            $(document).trigger('chat:hide_found_users');
        });

        ajax.fail((resp) => {
            this.setState({error_message: {errors: resp.responseJSON.errors, status: 'danger', show: true}})
        });
    }

    hideErrorMessage() {
        this.setState({error_message: {errors: [], status: '', show: false}})
    }

    render() {
        let margin = {
            marginRight: '5px'
        };

        let username = (this.state.user) ? this.state.user.username : '';
        let error_message = (
            <div className={`alert alert-${this.state.error_message.status}`} role="alert">
                <button type="button" className="close" onClick={this.hideErrorMessage.bind(this)}>
                    <span aria-hidden="true">&times;</span>
                </button>
                <strong>Error!</strong><br/>
                <ul>
                    {this.state.error_message.errors.map((error, i) => <li key={i}>{error}</li>)}
                </ul>
            </div>
        );

        return (
            <div className="modal fade" id="modalNewMessage" tabIndex="-1" role="document"
                 aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div className="modal-dialog" role="document">
                    <div className="modal-content">
                        <div className="modal-header">
                            <h4 className="modal-title" id="exampleModalLabel">New message to <b>{username}</b></h4>
                            <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div className="modal-body">

                            {(this.state.error_message.show) ? error_message : ''}

                            <div className="form-group">
                                <label htmlFor="message-text" className="form-control-label">Message:</label>
                                <textarea className="form-control" id="message-text" required
                                          onChange={(e) => this.setState({message: e.target.value})}
                                          value={this.state.message} placeholder="Type your message"/>
                            </div>
                        </div>
                        <div className="modal-footer">
                            <button type="button" className="btn btn-secondary" data-dismiss="modal" style={margin}>
                                Close
                            </button>
                            <button type="button" className="btn btn-primary" onClick={this.prepareMessage.bind(this)}>
                                Send message
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        )
    }


}