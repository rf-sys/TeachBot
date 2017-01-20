class WrapperSubscriber extends React.Component {
    constructor(props) {
        super(props)
    }

    render() {
        let url = '/users/' + this.props.subscriber.id;

        return (
            <a href={url} className="list-group-item list-group-item-action">
                <div className="row justify-content-around">
                    <div className="col-3">
                        <img src={this.props.subscriber.avatar} className="course-subscriber-avatar rounded-circle"/>
                    </div>
                    <div className="col-9 align-self-center text-center">
                        {this.props.subscriber.username}
                    </div>
                </div>
            </a>
        )
    }
}