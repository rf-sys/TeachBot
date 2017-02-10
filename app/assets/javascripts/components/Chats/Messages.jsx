class Messages extends React.Component {
    constructor(props) {
        super(props)
    }

    render() {
        let messages = this.props.messages.map((message) => {
            return <Message message={message} key={message.id}/>
        });

        return (
            <div>
                <ReactCSSTransitionGroup transitionName={{enter: "zoomIn", leave: "zoomOut"}}
                                         id={`chat_${this.props.chat_id}_messages_block`}
                                         transitionEnterTimeout={1000} transitionLeaveTimeout={1000}>
                {messages}
                </ReactCSSTransitionGroup>
            </div>
        )
    }
}