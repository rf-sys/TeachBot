class Messages extends React.Component {
    constructor(props) {
        super(props)
    }

    render() {
        let messages = this.props.messages.map((message, i) => {
            return <Message message={message} key={i}/>
        });

        return (
            <div>
                {messages}
            </div>
        )
    }
}