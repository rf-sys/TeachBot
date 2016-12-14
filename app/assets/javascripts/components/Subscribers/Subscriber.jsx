class Subscriber extends React.Component {
    constructor(props) {
        super(props)
    }

    unsubscribe() {
        let ajax = jQuery.ajax({
            url: `/courses/${this.props.course}/subscribers/${this.props.subscriber.id}`,
            type: 'DELETE',
            dataType: 'json'
        });

        ajax.done((response) => {
            this.props.unsubscribe(response.user, response.status);
        }).fail((response) => {
            this.props.setMessage(response.responseJSON.status);
        })

    }

    render() {
        return (
            <tr>
                <td>
                    <img src={this.props.subscriber.avatar} className="course-subscriber-avatar"/>
                </td>
                <td>{this.props.subscriber.username}</td>
                <td>
                    <button className="btn btn-outline-danger" onClick={this.unsubscribe.bind(this)}>
                        Unsubscribe
                    </button>
                </td>
            </tr>
        )
    }
}