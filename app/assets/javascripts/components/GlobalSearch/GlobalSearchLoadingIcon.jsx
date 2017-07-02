class GlobalSearchLoadingIcon extends React.Component {
    constructor(props) {
        super(props)
    }

    loadingView() {
        return (
            <span className="status_icon">
                <i className="fa fa-spinner fa-pulse fa-3x fa-fw"/>
                <span className="sr-only">Loading...</span>
            </span>
        )
    }

    render() {
        if (this.props.loading)
            return this.loadingView();
        else
            return null;
    }
}


GlobalSearchLoadingIcon.propTypes = {
    loading: React.PropTypes.bool
};