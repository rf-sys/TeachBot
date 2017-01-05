class Conversations extends React.Component {
    constructor(props) {
        super(props);
        this.state = {dialogs: []};
        this.ChatGeneratorFromInitiator = this.ChatGeneratorFromInitiator.bind(this);
        this.ChatGeneratorFromActionCable = this.ChatGeneratorFromActionCable.bind(this);
        this.generateChat = this.generateChat.bind(this);
        this.sortByLastMessage = this.sortByLastMessage.bind(this);
    }

    componentDidMount() {
        this.ChatGeneratorFromInitiator();
        this.ChatGeneratorFromActionCable();
        let ajax = $.post('/api/conversations');
        ajax.done((resp) => {

            this.setState({dialogs: resp});
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
        $(document).unbind('chat:new_chat').on('chat:new_chat', function (event, chat) {
            App.chat.perform('new_chat', {chat_id: chat.id, recipient: chat.recipient, chat: chat});
            this.generateChat(chat);

            $('#modalNewMessage').modal('hide');
            $(`#collapse_${chat.id}_dialog`).collapse('show');

        }.bind(this));
    }

    ChatGeneratorFromActionCable() {
        $(document).unbind('chat:new_chat:action_cable').on('chat:new_chat:action_cable', function (event, chat) {
            this.generateChat(chat);
        }.bind(this))
    }

    generateChat(chat) {
        let dialogs = this.state.dialogs.slice();
        dialogs.unshift(chat);
        this.setState({dialogs: dialogs});
    }

    updateDialogPosition(message) {
        let index = _.findIndex(this.state.dialogs, (d) => d.id == message.chat_id);
        let dialogs = this.state.dialogs;
        _.set(dialogs[index], 'last_message', message);

        this.setState({dialogs: dialogs});
    }

    render() {

        let sorted_dialogs = this.state.dialogs.sort(this.sortByLastMessage);

        let dialogs = sorted_dialogs.map((dialog) => {
            return <Conversation dialog={dialog} key={dialog.id} current_user={this.props.current_user}
                                 updateDialogPosition={this.updateDialogPosition.bind(this)}/>
        });
        return (
            <div>
                <ConvFindUsers/>
                <h1 className="text-xs-center">Dialogs</h1>
                <div id="dialogs_collapse" role="tablist" aria-multiselectable="true">
                    {dialogs}
                </div>
            </div>
        )
    }
}