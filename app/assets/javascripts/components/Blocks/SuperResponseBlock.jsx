class SuperResponseBlock extends React.Component {
    constructor(props) {
        super(props);
        this.state = {show: false}
    }

    componentDidMount() {
        this.setState({show: true});
    }

    hide() {
        this.setState({show: false});
    }

    render() {
        let view = (
            <div className={`alert ${this.props.type} animated`}
                 style={{marginBottom: 0, borderRadius: 0}}>
                <button type="button" className="close" onClick={this.hide.bind(this)}>
                    <span aria-hidden="true">&times;</span>
                </button>
                {this.props.message}
            </div>
        );
        return(
            <ReactCSSTransitionGroup transitionName={{enter: "lightSpeedIn", leave: "lightSpeedOut"}}
                                     transitionEnterTimeout={1000} transitionLeaveTimeout={1000}>
                {this.state.show ? view : null}
            </ReactCSSTransitionGroup>
        )
    }
}