class NotificationsCounter extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        let counter = <span className="animated badge badge-danger">{this.props.count}</span>;

        return (
            <ReactCSSTransitionGroup transitionName={{enter: "zoomIn", leave: "zoomOut"}}
                                     transitionEnterTimeout={1000} transitionLeaveTimeout={1000}>
                {this.props.count ? counter : null}
            </ReactCSSTransitionGroup>
        )
    }
}