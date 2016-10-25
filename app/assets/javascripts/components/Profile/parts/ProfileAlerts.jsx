class ProfileAlerts extends React.Component {
    constructor(props) {
        super(props);
        this.state = {list: props.list, success: props.success};
        this.props = props;

    }

    resetList() {
        this.setState({list: []});
        this.props.resetResponseData();
    }

    render() {
        var type;
        if (this.state.success == true)
            type = "alert alert-success load-fade";
        else
            type = "alert alert-danger load-fade";

        var margin = {
            marginBottom: '0'
        };


        var node;

        if (this.state.list.length <= 1)
            node = <span>{this.state.list}</span>;
        else {
            node = <ul style={margin}>
                {this.state.list.map((item, i) => {
                    return <li key={i}>{item}</li>
                })}
            </ul>;
        }

        return (
            <div className={type} role="alert">
                <button type="button" className="close" onClick={this.resetList.bind(this)}>
                    <span aria-hidden="true">&times;</span>
                </button>
                {node}
            </div>
        )
    }

}

export default ProfileAlerts