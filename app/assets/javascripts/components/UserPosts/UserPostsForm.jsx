class UserPostsForm extends React.Component {
    constructor(props) {
        super(props);

        this.state = {text: '', attachments: [], attachment: '', status_text: '', status: '', loading: false};
        this.editor = null;

        this.setAttachments = this.setAttachments.bind(this);
        this.setAttachment = this.setAttachment.bind(this);
        this.createPost = this.createPost.bind(this);
        this.resetStatusAlert = this.resetStatusAlert.bind(this);
    }

    // prepare form
    componentDidMount() {
        const post_editor = new wysihtml5.Editor('post_editor');

        this.editor = $(post_editor.editableElement);

        this.editor.keyup(() => {
            this.setState({text: this.editor.html()});
        });
    }

    // set attachments to state (returns from Attachments component)
    setAttachments(attachments) {
        this.setState({attachments: attachments});
    }

    // get new attachment url from menu
    setAttachment(url) {
        this.setState({attachment: url});
    }

    createPost() {
        this.setState({status_text: 'Loading...', status: 'info', loading: true});

        let ajax = $.post('/posts', {
            post: {
                text: this.state.text,
                attachments_attributes: this.state.attachments
            }
        });

        ajax.done((post) => {
            this.resetStatusAlert();
            this.resetForm();
            $(document).trigger('attachments:clearAll');
            this.props.addPost(post);
        });

        ajax.fail((response) => {
            console.log(response);
            this.setState({status_text: response.responseJSON.errors[0], status: 'danger'});
        });

        ajax.always(() => this.setState({loading: false}));
    }

    resetStatusAlert() {
        this.setState({status_text: ''});
    }

    resetForm() {
        this.editor.text('');
        this.setState({text: ''});
        this.setAttachment('');
        this.setAttachments([]);
    }

    render() {
        return (
            <div>
                <StatusAlert status_text={this.state.status_text} status={this.state.status}
                             resetStatusAlert={this.resetStatusAlert}/>
                <div id="post_editor"/>
                <hr/>
                <UserPostsMenu setAttachment={this.setAttachment} createPost={this.createPost}
                               loading={this.state.loading}/>
                <Attachments text={this.state.text} attachment={this.state.attachment}
                             setAttachments={this.setAttachments}
                />
            </div>
        )
    }
}

UserPostsForm.PropTypes = {
    addPost: React.PropTypes.func
};
