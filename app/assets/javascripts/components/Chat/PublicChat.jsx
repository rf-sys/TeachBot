class PublicChat extends React.Component {
    constructor(props) {
        super(props);
        this.getMessages = this.getMessages.bind(this);
        this.state = {
            messages: [],
            next_page: 1,
            total_pages: 1
        }
    }

    componentDidMount() {
        this.getMessages();
        $(document).unbind('chat:1:receive_message').on('chat:1:receive_message', function (event, data) {
            let messages = this.state.messages.slice();
            messages.push(data.message);
            this.setState({messages: messages});
        }.bind(this))
    }

    getMessages() {
        let ajax = $.post(`/api/conversations/1/messages?page=${this.state.next_page}`);
        ajax.done((resp) => {
            if (resp.page == 1)
                this.setState({messages: resp.messages.reverse()});
            else {
                let messages = this.state.messages.slice();
                resp.messages.map((message) => {
                    messages.unshift(message);
                });

                this.setState({messages: messages});

            }

            this.setState({next_page: resp.page + 1, current_page: resp.page, total_pages: resp.total_pages})
        });
    }

    render() {
        let no_messages = <div className="text-xs-center">Messages not found</div>;
        let older_msg_btn = (
            <button type="button" className="btn btn-outline-secondary btn-block"
                    onClick={this.getMessages}>
                Older messages
            </button>
        );

        return (
            <div>
                {(this.state.current_page < this.state.total_pages) ? older_msg_btn : ''}
                {(this.state.messages.length) ? <Messages messages={this.state.messages}/> : no_messages}
            </div>
        )
    }
}