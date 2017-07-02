class StatusAlert extends  React.Component {
    constructor(props) {
        super(props);

        this.resetStatusAlert = this.resetStatusAlert.bind(this);

        this.renderAlertStatus = this.renderAlertStatus.bind(this);
        this.renderAnimation = this.renderAnimation.bind(this);
    }

    resetStatusAlert() {
        this.props.resetStatusAlert();
    }

    renderAlertStatus() {
        return `alert-${this.props.status}`;
    }

    renderAnimation() {
        return this.props.status === 'danger' ? 'animated bounceIn' : '';
    }

    render() {
        if (this.props.status_text)
            return (
                <div className={`alert alert-${this.props.status} ${this.renderAnimation()}`} role="alert">
                    <button type="button" className="close"
                    onClick={this.resetStatusAlert}>
                        <span aria-hidden="true">&times;</span>
                    </button>
                    {this.props.status_text}
                </div>
            );
        else
            return <div/>;
    }
}

StatusAlert.PropTypes = {
    status_text: React.PropTypes.string, // shows alert's content
    status: React.PropTypes.string // responsible for alert background (success, info, warning, danger)
};