var List = React.createClass({
    render() {
        var margin = {
            marginBottom: '0'
        };
        var List;
        if (this.props.messages.length < 2)
            List = <span>{this.props.messages[0]}</span>;
        else
            List = <ul style={margin}>{this.props.messages.map((message, i) => {
                return (<li key={i}>{message}</li>);
            })}</ul>;

        return <div>{List}</div>
    }
});
List.defaultProps = {
    messages: []
};
