class ConvUnreadMessages extends React.Component {
    constructor(props) {
        super(props);
        this.state = {loaded_once: false, messages: [], count: this.props.count || 0}
    }

    loadUnreadMessages() {
        $(this.dropdown).toggleClass('open');

        if (!this.state.loaded_once) {
            let ajax = $.post('/api/messages/unread/all', {chat_id: this.props.dialog.id});
            ajax.done(
                /** @param {{ messages: array }} response - a collection of unread messages*/
                (response) => {
                    this.setState({messages: response.messages});
                });

            this.setState({loaded_once: true});
        }
    }

    removeMessage(id) {
        let messages = this.state.messages.filter((message) => {
           return message.id != id
        });

        this.setState({messages: messages, count: this.state.count - 1});

        if (!this.state.count) {
            $(this.dropdown).removeClass('open');
        }
    }


    render() {
        let messages = this.state.messages.map((message, i) => {
            return <ConvUnreadMessage message={message} key={i}
                                      removeMessage={this.removeMessage.bind(this)}/>
        });

        let button_class_toggle = `btn ${(this.state.count) ? 'btn-outline-danger' : 'btn-outline-secondary' } 
        rounded-circle`;
        return (
            <div className="dropdown" ref={(input) => { this.dropdown = input; }}>
                <button className={button_class_toggle} type="button"
                        id={`chat_${this.props.dialog.id}_unread_messages_dropdown`}
                        onClick={this.loadUnreadMessages.bind(this)}
                        aria-haspopup="true" aria-expanded="false"
                title="Unread messages">
                    {this.state.count}
                </button>
                <div className="dropdown-menu unread_messages_dropdown_menu"
                     id={`conv_${this.props.dialog.id}_um_dropdown_menu`}
                     aria-labelledby={`chat_${this.props.dialog.id}_unread_messages_dropdown`}>
                    {(this.state.count) ? messages : <div>No unread messages</div>}
                </div>
            </div>
        );
    }
}