class Post extends React.Component {
    constructor(props) {
        super(props);
        this.destroy = this.destroy.bind(this)
    }

    destroy() {
        this.props.destroyPost(this.props.post)
    }

    render() {

        let date = moment(this.props.post.created_at).format('LLL');

        let trash = <i className="fa fa-trash-o trash-icon-post" aria-hidden="true" title="Delete post"
                       onClick={this.destroy}/>;
        return (
            <div className="card card-block load-fade">
                {(this.props.user == this.props.auth) ? trash : ''}
                <h4 className="card-title">{this.props.post.title}</h4>
                <p className="card-text">
                    {this.props.post.text}
                </p>
                <p className="card-text">
                    <small className="text-muted">
                        {date}
                    </small>
                </p>
            </div>
        )
    }
}