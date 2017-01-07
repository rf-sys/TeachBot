class ChatMessages extends React.Component {
    constructor(props) {
        super(props)
    }

    render() {
        let messages = this.props.messages.map((message, i) => {
            return <ChatMessage message={message} key={i}/>
        });

        return (
            <div>
                {messages}
            </div>
        )
    }
}