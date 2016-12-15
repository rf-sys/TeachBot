class WrapperSubscriber extends React.Component {
    constructor(props) {
        super(props)
    }

    render() {
        let url = '/users/' + this.props.subscriber.id;

        return (
            <a href={url} className="list-group-item list-group-item-action">
                <div className="row flex-items-xs-middle">
                    <div className="col-md-3">
                        <img src={this.props.subscriber.avatar} className="course-subscriber-avatar rounded-circle"/>
                    </div>
                    <div className="col-md-9">
                        {this.props.subscriber.username}
                    </div>
                </div>


            </a>
        )
    }
}