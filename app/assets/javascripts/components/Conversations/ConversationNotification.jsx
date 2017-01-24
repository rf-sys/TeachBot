class ConversationNotification extends React.Component {
    constructor(props) {
        super(props);
        this.state = {text: ''}
    }

    componentDidMount() {
        console.log('mounted');
        $(document)
            .unbind(`chat:${this.props.dialog_id}:notification`)
            .on(`chat:${this.props.dialog_id}:notification`, (event, text) => {
                this.setState({text: text});
                console.log('text', text)
            });
    }

    hide() {
        this.setState({text: ''})
    }

    render() {
        let view = (
            <div className="animated">
                <hr/>
                <div className="text-center">
                    <button type="button" className="close" onClick={this.hide.bind(this)}>
                        <span aria-hidden="true">&times;</span>
                    </button>
                    {this.state.text}
                </div>
            </div>
        );
       return (
           <ReactCSSTransitionGroup transitionName={{enter: "zoomIn", leave: "zoomOut"}}
                                    transitionEnterTimeout={1000} transitionLeaveTimeout={1000}>
               {this.state.text.length ? view : ''}
           </ReactCSSTransitionGroup>
       )
    }
}