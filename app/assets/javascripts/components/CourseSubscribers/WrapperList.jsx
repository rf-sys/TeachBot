class WrapperList extends React.Component {
    constructor(props) {
        super(props)
    }

    render() {
        let subscribers = this.props.subscribers.map((subscriber, i) => {
            return <WrapperSubscriber subscriber={subscriber} key={i}/>
        });
        return (
            <div>
                <h2 className="text-xs-center">Subscribers</h2>
                <div className="list-group">
                    {subscribers}
                </div>
            </div>

        )
    }
}