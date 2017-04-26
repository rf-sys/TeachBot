class UserPostsIndex extends React.Component {
    constructor(props) {
        super(props);

        this.state = { posts: [], current_page: 1, total_pages: 1 };

        this.addPost = this.addPost.bind(this);
        this.loadPosts = this.loadPosts.bind(this);
    }

    componentDidMount() {
        this.loadPosts();
    }

    loadPosts(page = 1) {
        let ajax = $.ajax(`/users/${this.props.target_user_id}/posts?page=${page}`);

        ajax.done((response) => {
            this.setState({
                posts: response.posts,
                current_page: response.current_page,
                total_pages: response.total_pages
            });
        });
    }

    addPost(post) {
        let posts = this.state.posts;
        posts.push(post);

        this.setState({ posts: posts });
    }

    render() {
        return (
            <div>
                <div className="box-shadow-block" style={{padding: '15px'}}>
                    <UserPostsForm addPost={this.addPost} />
                </div>
                {/* A list of posts */}
                <UserPosts posts={this.state.posts} />
                <Paginator action={this.loadPosts}
                           current_page={this.state.current_page}
                           total_pages={this.state.total_pages}/>
            </div>
        )
    }
}

UserPostsIndex.PropTypes = {
    target_user_id: React.PropTypes.number,
    auth_user_id: React.PropTypes.number
};