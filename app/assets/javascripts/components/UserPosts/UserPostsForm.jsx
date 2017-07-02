class UserPostsForm extends React.Component {
    constructor(props) {
        super(props);

        this.state = {text: '', attachments: [], attachment: '', status_text: '', status: '', loading: false};

        this.setAttachments = this.setAttachments.bind(this);
        this.setAttachment = this.setAttachment.bind(this);
        this.createPost = this.createPost.bind(this);
        this.resetStatusAlert = this.resetStatusAlert.bind(this);
    }

    // prepare form
    componentDidMount() {
        const post_editor = new wysihtml5.Editor('post_editor');

        let post_editor_elem = $(post_editor.editableElement);

        post_editor_elem.keyup(() => {
            this.setState({text: post_editor_elem.html()});
        });

        $(document).on('attachments:clearAll', () => {
            post_editor_elem.text('');
            this.setState({text: ''});
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
