var ErrorsList = React.createClass({
    render() {
        var margin = {
            marginBottom: '0'
        };
        var ErrorList = this.props.errors.map((error, i) => {
            return (<li key={i}>{error}</li>);
        });

        return <ul style={margin}>{ErrorList}</ul>
    }
});
ErrorsList.defaultProps = {
    errors: []
};
