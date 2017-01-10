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
                {messages}
            </div>
        )
    }
}