class UserPost extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        let attachments = _.map(this.props.post.attachments, (attachment) => {
            return <UserPostsAttachment attachment={attachment} key={attachment.id}/>
        });

        return (
            <div className="user_post animated fadeIn">
                <p className="lead" dangerouslySetInnerHTML={{__html: this.props.post.text}}/>
                {attachments}
                <div className="text-right text-muted user_post_date">
                    {moment(this.props.post.created_at).format('MMM Do YY')}
                </div>
            </div>
        )
    }

}

UserPost.PropTypes = {
    post: React.PropTypes.object
};