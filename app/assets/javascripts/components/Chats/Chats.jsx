class Chats extends React.Component {
    constructor(props) {
        super(props);
        this.state = {chats: [], selected_chat: null};
        this.ChatGeneratorFromInitiator = this.ChatGeneratorFromInitiator.bind(this);
        this.ChatGeneratorFromActionCable = this.ChatGeneratorFromActionCable.bind(this);
        this.generateChat = this.generateChat.bind(this);
        this.sortByLastMessage = this.sortByLastMessage.bind(this);
    }

    componentDidMount() {
        this.ChatGeneratorFromInitiator();
        this.ChatGeneratorFromActionCable();
        let ajax = $.getJSON('/chats');
        ajax.done((resp) => {
            this.setState({chats: resp});
        });
    }

    sortByLastMessage(current, next) {
        if (!current.last_message && !next.last_message) return 0;

        if (!current.last_message) return 1;

        if (!next.last_message) return -1;

        if (current.last_message.created_at < next.last_message.created_at)
            return 1;
        if (current.last_message.created_at > next.last_message.created_at)
            return -1;
        return 0;
    }

    ChatGeneratorFromInitiator() {
        $(document).unbind('chat:new_chat').on('chat:new_chat', (event, chat) => {
            App.chat.perform('send_new_chat', {chat: chat});
            this.generateChat(chat);
            $('#modalNewMessage').modal('hide');
            $(`#collapse_${chat.id}_chat`).collapse('show');
        });
    }

    ChatGeneratorFromActionCable() {
        $(document).unbind('chat:new_chat:action_cable').on('chat:new_chat:action_cable', (event, chat) => {
            this.generateChat(chat);
        })
    }

    generateChat(chat) {
        let chats = this.state.chats.slice();
        chats.unshift(chat);
        this.setState({chats: chats});
    }

    updateChatPosition(message) {
        let index = _.findIndex(this.state.chats, (d) => d.id == message.chat_id);
        let chats = this.state.chats;
        _.set(chats[index], 'last_message', message);

        this.setState({chats: chats});
    }

    leave(id) {
        let chats = _.filter(this.state.chats, (chat) => chat.id != id);

        this.setState({chats: chats});
    }

    render() {

        let sorted_chats = this.state.chats.sort(this.sortByLastMessage);

        let chats = sorted_chats.map((chat) => {
            return <Chat chat={chat} key={chat.id} current_user={this.props.current_user}
                         updateChatPosition={this.updateChatPosition.bind(this)}
                         leave={this.leave.bind(this)}/>
        });

        let no_chats_message = (
            <p className="lead text-center">
                <b>No chats!</b> To create a new one - type a username of the user in the field above and send him a message.
                chat will be created immediately
            </p>
        );

        return (
            <div>
                <ChatFindUsers/>
                <h1 className="text-center">Chats</h1>
                <div id="chats_collapse" role="tablist" aria-multiselectable="true">
                    {chats.length ? chats : no_chats_message}
                </div>
            </div>
        )
    }
}