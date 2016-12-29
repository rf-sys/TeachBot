const ResponseMessagesBlock = React.createClass({
    getInitialState() {
        return {
            list: [],
            success: false
        };
    },
    componentDidMount() {
        this.listenAjax();
    },
    listenAjax() {
        $(document)
            .on('RMB:success', function (event, message) {
                this.setState({list: [], success: true});
                this.setState({list: [message], success: true});
            }.bind(this))
            .on('ajax:error', function (event, response) {
                this.setState({list: [], success: true});
                this.setState({list: response.responseJSON.errors, success: false});
            }.bind(this));
    },
    clearErrors() {
        this.setState({list: []})
    },
    renderErrors() {
        var type;

        if (this.state.success)
            type = "alert alert-success load-fade";
        else
            type = "alert alert-danger load-fade";


        let div = (
            <div className={type} id="ResponseMessagesBlock">
                <button type="button" className="close" onClick={this.clearErrors}>
                    <span>&times;</span>
                </button>
                <ReactCSSTransitionGroup transitionName="fade"
                                         transitionEnterTimeout={500}
                                         transitionLeaveTimeout={300}>
                    <List messages={this.state.list}/>
                </ReactCSSTransitionGroup >
            </div>
        );

        let block = (this.state.list.length) ? div : '';
        return (
                <ReactCSSTransitionGroup transitionName="fade"
                                         transitionEnterTimeout={500}
                                         transitionLeaveTimeout={300}>
                    {block}
                </ReactCSSTransitionGroup >
        );
    },
    render() {

        return (this.state.list.length) ? this.renderErrors() : null


    }
});