class Notifications extends React.Component {
    constructor(props) {
        super(props);
        this.state = {show: false, notifications: [], count: this.state.notifications.length}
    }

    componentDidMount() {
        $(document).on('notification:receive', function (event, data) {
            console.log(data);
        })
    }

    toggleNotifications(e) {
        e.preventDefault();
        console.log('opened');
        this.setState({show: !this.state.show});
    }

    render() {
        let notifications_block = (
        <div>
            <div className="notifications-block_triangle"></div>
            <div className="notifications-block box-shadow-block">
                Hi!
            </div>
        </div>
        );
        return (
            <div className="notifications-bell">
                <a className="nav-link active" href="#" onClick={this.toggleNotifications.bind(this)}>
                    <i className="fa fa-bell" aria-hidden="true"/>
                </a>
                {(this.state.show) ? notifications_block : ''}
            </div>
        )
    }
}