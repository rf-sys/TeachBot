class UserPosts extends React.Component {
    constructor(props) {
        super(props);

        this.renderPosts = this.renderPosts.bind(this);
    }

    /**
     * @return {Array}
     */
    renderPosts() {
        let posts = _.orderBy(this.props.posts, 'id', 'desc');
        return _.map(posts, (post) => <UserPost post={post} key={post.id}/>);
    }

    render() {
        let posts = this.renderPosts();

        if (posts.length)
            return <div className="user_posts">{posts}</div>;
        else
            return null;
    }
}

UserPosts.PropTypes = {
    posts: React.PropTypes.array
};