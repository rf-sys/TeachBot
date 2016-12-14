class Message extends React.Component {
    constructor(props) {
        super(props)
    }

    hideMessage() {
        this.props.hideMessage();
    }

    render() {
        if (this.props.show)
            return (
                <div className="alert alert-info alert-dismissible load-fade" role="alert">
                    <button type="button" className="close" onClick={this.hideMessage.bind(this)}>
                        <span aria-hidden="true">&times;</span>
                    </button>
                    {this.props.message}
                </div>
            );
        else
            return <div></div>
    }
}