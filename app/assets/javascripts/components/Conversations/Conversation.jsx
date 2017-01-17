class Conversation extends React.Component {
    constructor(props) {
        super(props);
        this.openIfHash = this.openIfHash.bind(this);
        this.setUsersList = this.setUsersList.bind(this);
        this.lastMessage = this.lastMessage.bind(this);
        this.getMessages = this.getMessages.bind(this);
        this.belongsToCurrentUser = this.belongsToCurrentUser.bind(this);
        this.state = {
            messages: (this.props.dialog.last_message) ? [this.props.dialog.last_message] : [],
            notification: {message: null, status: null, show: false},
            next_page: 1,
            total_pages: 1,
            loaded_once: false,
            loading_cog: false,
            unread_messages_block_show: false
        }
    }

    componentDidMount() {
        $(document)
            .unbind(`chat:${this.props.dialog.id}:receive_message`)
            .on(`chat:${this.props.dialog.id}:receive_message`, function (event, response) {
                let messages = this.state.messages.slice();
                messages.push(response.message);
                this.setState({messages: messages});

                if (this.props.current_user.id != response.message.user_id)
                    this.props.updateDialogPosition(this.state.messages[this.state.messages.length - 1]);

            }.bind(this));

        $(`#collapse_${this.props.dialog.id}_dialog`).on('show.bs.collapse', function () {
            if (!this.state.loaded_once) {
                this.getMessages();
                this.setState({loaded_once: true});
            }
        }.bind(this));
        this.openIfHash();
    }

    openIfHash() {
        let expression = /#dialog=(\w+)/;
        let hash = window.location.hash;
        let dialog_id = hash.replace(expression, '$1');

        if (dialog_id.length)
            $(`#collapse_${dialog_id}_dialog`).collapse('show')
    }

    setUsersList() {
        let users = this.props.dialog.users.filter((user) => {
            return user.id != this.props.current_user.id
        });

        if (!users.length) {
            users.push(this.props.current_user)
        }

        return users.map((user, i) => {
            return (
                <a href={`/users/${user.id}`} key={i} target="_blank">
                    <img src={user.avatar} alt="not found" className="rounded-circle small_chat_user_avatar"/>
                    &nbsp;
                    {user.username}
                    &nbsp;
                </a>
            )
        });
    }

    lastMessage() {
        let message = this.state.messages[this.state.messages.length - 1];
        if (message)
            return (
                <div>
                    <div>{message.user.username}: {message.text}
                        &nbsp;
                        <small>({moment(message.created_at).fromNow()})</small>
                    </div>
                </div>

            );
        else
            return ''
    }


    getMessages() {
        this.setState({loading_cog: true});

        let ajax = $.post(`/api/conversations/${this.props.dialog.id}/messages?page=${this.state.next_page}`);
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

        ajax.always(() => {
            this.setState({loading_cog: false});
        });
    }

    sendMessage(text) {
        let ajax = $.post(`/chats/${this.props.dialog.id}/messages`, {message: {text: text}});
        ajax.done((resp) => {
            this.setState({notification: {message: resp.message, status: 'success', show: true}});
            this.props.updateDialogPosition(this.state.messages[this.state.messages.length - 1]);
        });
    }

    hideNotification() {
        this.setState({notification: {message: null, status: null, show: false}})
    }

    //helpers

    /**
     * @return {boolean}
     */
    belongsToCurrentUser() {
        console.log(this.props.dialog.initiator_id, this.props.current_user.id);
        return this.props.dialog.initiator_id == this.props.current_user.id
    }

    render() {
        let collapse = `collapse_${this.props.dialog.id}_dialog`;
        let heading = `heading_${this.props.dialog.id}_dialog`;
        let no_messages = <div className="text-xs-center">Messages not found</div>;
        let older_msg_btn = (
            <button type="button" className="btn btn-outline-secondary btn-block no_border_radius"
                    onClick={this.getMessages}>
                Older messages
            </button>
        );
        let loading_cog = (
            <div className="text-xs-center">
                <i className="fa fa-cog fa-spin fa-3x fa-fw"/>
                <span className="sr-only">Loading...</span>
            </div>
        );

        let services_for_author = (
          <div>
              <a className="dropdown-item" href="#">Add participant</a>
              <a className="dropdown-item" href="#">Remove participant</a>
          </div>
        );

        return (
            <div className="card" style={{marginBottom: '5px'}}>
                <div className="card-header" role="tab" id={heading}>
                    <h5 className="mb-0">
                        <div className="row flex-items-xs-middle">
                            <div className="col-md-8 flex-xs-middle text-xs-center text-md-left">
                                {this.setUsersList()}
                            </div>
                            <div className="col-md-4 text-sm-right text-xs-center flex-xs-middle">
                                <div className="d-flex justify-content-between">
                                    <div className="btn-group" role="group"
                                         aria-label="Button group with nested dropdown">
                                        <button data-toggle="collapse" data-parent="#dialogs_collapse"
                                                href={`#${collapse}`}
                                                aria-expanded="false" aria-controls={collapse}
                                                className="btn btn-outline-primary collapsed">
                                            Open dialog
                                        </button>
                                        <div className="btn-group" role="group">
                                            <button id="btnGroupDrop1" type="button"
                                                    className="btn btn-outline-primary dropdown-toggle"
                                                    data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <i className="fa fa-cogs" aria-hidden="true"></i>
                                            </button>
                                            <div className="dropdown-menu" aria-labelledby="btnGroupDrop1">
                                                {this.belongsToCurrentUser() ? services_for_author : ''}
                                            </div>
                                        </div>
                                    </div>
                                    <ConvUnreadMessages dialog={this.props.dialog}
                                                        count={this.props.dialog.unread_messages_count}/>

                                </div>
                            </div>
                        </div>
                        <hr/>
                        <div>
                            {this.lastMessage()}
                        </div>
                    </h5>
                </div>

                <div id={collapse} name={collapse} className="collapse" role="tabpanel" aria-labelledby={heading}>
                    {((this.state.current_page < this.state.total_pages) && !this.state.loading_cog)
                        ? older_msg_btn : ''}
                    <div className="card-block">
                        {(this.state.loading_cog) ? loading_cog : ''}
                        {(this.state.messages.length) ? <Messages messages={this.state.messages}/> : no_messages}
                        <hr/>
                        <ConvMessageNotification notification={this.state.notification}
                                                 hideNotification={this.hideNotification.bind(this)}/>
                        <SendMessageForm sendMessage={this.sendMessage.bind(this)}/>
                    </div>
                </div>
            </div>
        )
    }
}