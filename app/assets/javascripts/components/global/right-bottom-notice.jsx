var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

var RightBottomNotice = React.createClass({

    getInitialState: function () {
        return {mounted: false, message: this.props.message};
    },
    componentDidMount() {
        this.setState({mounted: true});

        // to prevent error in the console if we go to another page before time is up
        var hide = setTimeout(() => this.setState({mounted: false}), 4000);

        $(document).on("turbolinks:before-visit", () => {
            clearTimeout(hide);
        });

    },
    render() {
        var child;

        if (this.state.mounted) {
            child = <Content message={this.state.message} type={this.props.type} />;
        }
        return (
            <ReactCSSTransitionGroup transitionName="fade"
                                     transitionEnterTimeout={500}
                                     transitionLeaveTimeout={300}>
                {child}
            </ReactCSSTransitionGroup>
        )
    }
});


function Content(props) {
    var className;

    if (props.type == 'success') className = 'alert alert-success layout_notice';

    if (props.type == 'info') className = 'alert alert-info layout_notice';

    if (props.type == 'danger') className = 'alert alert-danger layout_notice';

    return (
        <div className={className} role="alert">
            {props.message}
        </div>
    )
}

RightBottomNotice.defaultProps = {
    message: null,
    type: 'info'
};
