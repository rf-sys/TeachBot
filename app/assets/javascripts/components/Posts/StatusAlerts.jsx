class StatusAlerts extends React.Component {
    constructor(props) {
        super(props);
        this.state = {errors: []}
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.errors.length) {
            this.setState({errors: nextProps.errors});
            setTimeout(() => {
                this.setState({errors: []});
            }, 4000);
        }
    }

    render() {

        let errors = this.state.errors.map((error, i) => {
            return <li key={i}>{error}</li>
        });
        let content = (
            <div className='alert alert-danger load-fade'>
                <ul>{errors}</ul>
            </div>
        );
        return (this.state.errors.length) ? content : <div></div>
    }
}

StatusAlerts.defaultProps = {
    message: ''
};