class ChatUnreadMessages extends React.Component {
    constructor(props) {
        super(props);
        this.state = {loaded_once: false, messages: [], count: this.props.count || 0}
    }

    componentDidMount() {
        $(document).unbind(`chat:${this.props.chat.id}:unread_messages:remove`)
            .on(`chat:${this.props.chat.id}:unread_messages:remove`, (event, message_id) => {
                console.log('message_id', message_id);
                if (this.state.count)
                    this.removeMessage(message_id);
            });
    }

    /**
     * Load unread messages from server if menu has been opened first time
     */
    loadUnreadMessages() {
        if (!this.state.loaded_once) {
            let ajax = $.post('/messages/unread', {chat_id: this.props.chat.id});
            ajax.done(
                /** @param {{ messages: array }} response - a collection of unread messages */
                (response) => {
                    this.setState({messages: response.messages});
                });

            this.setState({loaded_once: true});
        }
    }

    /**
     * Exclude message with given id from messages array and decrease count of unread messages.
     * @param id
     */
    removeMessage(id) {
        let messages = this.state.messages.filter((message) => {
            return message.id != id
        });

        this.setState({messages: messages, count: this.state.count - 1});

        if (!this.state.count) {
            $(this.dropdown).removeClass('show');
        }
    }

    /**
     * Mark all messages of the current chat as read. Reset count and unread messages array.
     * @param e
     */
    markAllAsRead(e) {
        e.preventDefault();
        let ajax = $.post('/messages/read/all', {chat_id: this.props.chat.id});

        ajax.done(
            /** @param {{ status: String }} response */
            (response) => {
                $(document).trigger('unread_messages:remove_specific_count', this.state.count);
                this.setState({count: 0, messages: []});
            });
    }

    render() {
        let messages = this.state.messages.map((message, i) => {
            return <ChatUnreadMessage message={message} key={i}
                                      removeMessage={this.removeMessage.bind(this)}/>
        });

        let display = (
            <div>
                <button className="btn btn-block btn-outline-warning" style={{marginBottom: '15px', borderRadius: '0'}}
                        onClick={this.markAllAsRead.bind(this)}>
                    Mark all as read
                </button>
                {messages}
            </div>
        );

        let button_class_toggle = `btn ${(this.state.count) ? 'btn-outline-danger' : 'btn-outline-secondary' } 
        rounded-circle`;
        return (
            <div className="dropdown" ref={(input) => { this.dropdown = input; }} name="unread_messages_dropdown">
                <button className={button_class_toggle} type="button"
                        id={`chat_${this.props.chat.id}_unread_messages_dropdown`}
                        onClick={this.loadUnreadMessages.bind(this)}
                        aria-haspopup="true" aria-expanded="false" data-toggle="dropdown"
                        title="Unread messages">
                    {this.state.count}
                </button>
                <div className="dropdown-menu unread_messages_dropdown_menu"
                     id={`conv_${this.props.chat.id}_um_dropdown_menu`}
                     aria-labelledby={`chat_${this.props.chat.id}_unread_messages_dropdown`}>
                    {(this.state.count) ? display : <h4 className="text-center">No unread messages</h4>}
                </div>
            </div>
        );
    }
}