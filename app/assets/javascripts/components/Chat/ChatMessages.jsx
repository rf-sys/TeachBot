class ChatMessages extends React.Component {
    constructor(props) {
        super(props)
    }

    render() {
        let messages = this.props.messages.map((message) => {
            return <ChatMessage message={message} key={message.id}/>
        });

        return (
            <div>
                <ReactCSSTransitionGroup transitionName={{enter: "zoomIn", leave: "zoomOut"}}
                                         transitionEnterTimeout={1000} transitionLeaveTimeout={1000}>
                    {messages}
                </ReactCSSTransitionGroup>
            </div>
        )
    }
}