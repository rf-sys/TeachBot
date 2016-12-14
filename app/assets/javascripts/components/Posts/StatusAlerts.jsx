class StatusAlerts extends React.Component {
    constructor(props) {
        super(props);
        this.state = {message: ''}
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.message) {
            this.setState({message: nextProps.message});

            setTimeout(() => {
                this.setState({message: ''});
            }, 4000);
        }
    }

    render() {

        let status = (this.props.status) ? 'alert alert-success load-fade' : 'alert alert-danger load-fade';

        let content = (
            <div className={status}>
                {this.state.message}
            </div>
        );
        return (this.state.message) ? content : <div></div>
    }
}

StatusAlerts.defaultProps = {
    message: ''
};