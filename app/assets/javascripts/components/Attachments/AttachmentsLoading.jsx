class AttachmentsLoading extends React.Component {
    constructor(props) {
        super(props)
    }

    render() {
        if (this.props.loading)
            return (
                <div className="alert alert-info" role="alert">
                    <i className="fa fa-spinner fa-pulse fa-3x fa-fw" style={{fontSize: '18px'}}/>&nbsp;
                    <span className="sr-only">Loading...</span>
                    Loading attachment...
                </div>
            );
        else return null
    }
}