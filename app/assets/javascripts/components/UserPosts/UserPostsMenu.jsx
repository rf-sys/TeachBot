class UserPostsMenu extends React.Component {
    constructor(props) {
        super(props);

        this.state = {url: ''};

        this.changeUrl = this.changeUrl.bind(this);
        this.addAttachment = this.addAttachment.bind(this);
        this.createPost = this.createPost.bind(this);
    }

    changeUrl(e) {
        this.setState({url: e.target.value});
    }

    addAttachment() {
        this.props.setAttachment(this.state.url);
        $('#attachmentModal').modal('hide');
        this.setState({url: ''});
    }

    createPost() {
        this.props.createPost();
    }

    render() {
        return (
            <div>
                <div className="text-right">
                    <ul className="list-inline">
                        <li className="list-inline-item">
                            <button type="button" className="btn btn-outline-info" data-toggle="modal"
                                    data-target="#attachmentModal">
                                Add attachment
                                &nbsp;<i className="fa fa-link" aria-hidden="true"/>
                            </button>
                        </li>
                        <li className="list-inline-item">
                            <button className="btn btn-outline-primary" onClick={this.createPost}
                                    disabled={this.props.loading}>
                                Create Post
                                &nbsp;
                                <i className="fa fa-paper-plane-o" aria-hidden="true"/>
                            </button>
                        </li>
                    </ul>
                </div>


                <div className="modal fade" id="attachmentModal" tabIndex="-1" role="dialog"
                     aria-labelledby="attachmentModallLabel" aria-hidden="true">
                    <div className="modal-dialog" role="document">
                        <div className="modal-content">
                            <div className="modal-header">
                                <h5 className="modal-title" id="attachmentModalLabel">New attachment</h5>
                                <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div className="modal-body">
                                <form>
                                    <div className="form-group">
                                        <label htmlFor="attachment-url" className="form-control-label">
                                            Attachment url:
                                        </label>
                                        <input type="text" className="form-control" id="attachment-url"
                                               placeholder="Example: https://www.google.com.ua/"
                                               onChange={this.changeUrl} value={this.state.url}/>
                                    </div>
                                </form>
                            </div>
                            <div className="modal-footer">
                                <button type="button" className="btn btn-secondary" data-dismiss="modal">Close</button>
                                <button type="button" className="btn btn-primary" onClick={this.addAttachment}>Add
                                    attachment
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}

UserPostsMenu.PropTypes = {
    setAttachment: React.PropTypes.func
};