class UnreadMessages extends React.Component {
    constructor(props) {
        super(props);
        this.state = {count: 0};
        this.updateCount = this.updateCount.bind(this);
    }

    componentDidMount() {

        $(document).unbind('unread_messages:remove').on('unread_messages:remove', () => {
            if (this.state.count) {
                let newCount = this.state.count - 1;
                this.updateCount(newCount);
            }
        });

        $(document).unbind('unread_messages:add').on('unread_messages:add', () => {
            console.log('initiate unread_messages:add');
            let newCount = this.state.count + 1;
            console.log('newCount', newCount);
            this.updateCount(newCount);
        });

        $(document).unbind('unread_messages:remove_specific_count')
            .on('unread_messages:remove_specific_count', (event, count) => {
            console.log('initiate unread_messages:add');
            let newCount = this.state.count - count;
            console.log('newCount', newCount);
            this.updateCount(newCount);
        });

        let count;
        if (count = sessionStorage.getItem('unread_messages:count')) {
            console.log('presence', parseInt(count));
            this.setState({count: parseInt(count)});
        } else {
            this.getUnreadMessagesCount();
        }
    }

    /**
     * Get unread messages and change state
     */
    getUnreadMessagesCount() {
        let ajax = $.post('/api/messages/unread/count');

        ajax.done(
            /** @param {{ count: number }} response */
            (response) => {
                this.setState({count: response.count});
                sessionStorage.setItem('unread_messages:count', response.count);
                console.log(response.count);
            });
    }

    /**
     * Set specific count
     * @param {number} count
     */
    updateCount(count) {
        console.log('updateCount');
        this.setState({count: count});
        sessionStorage.setItem('unread_messages:count', count);
    }

    render() {
        let template = (
            <div className="unread_messages_block_counter_wrapper animated hidden-md-down">
                <div className="live_light notifications-block_counter_inner_live"></div>
                <div className="animated tag-danger notifications-block_counter_inner_counter">
                    {this.state.count}
                </div>
            </div>
        );

        return (
            <ReactCSSTransitionGroup transitionName={{enter: "zoomIn", leave: "zoomOut"}}
                                     transitionEnterTimeout={1000} transitionLeaveTimeout={1000}>
                {(this.state.count) ? template : ''}
            </ReactCSSTransitionGroup>
        )
    }
}