class Posts extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            posts: [],
            error: null,
            loading: false,
            message: null,
            messageStatus: true,
            total_pages: null,
            current_page: null
        };

        this.createPost = this.createPost.bind(this);
        this.getPosts = this.getPosts.bind(this);
        this.destroyPost = this.destroyPost.bind(this);
        this.loadMorePosts = this.loadMorePosts.bind(this);
    }

    componentDidMount() {
        this.getPosts()
    }

    getPosts(page = 1) {
        this.setState({loading: true});

        let ajax = jQuery.get(`/users/${this.props.user}/posts?page=${page}`, (response) => {


            let posts = this.state.posts.slice();

            response.posts.forEach((item) => {
               posts.push(item);
            });

            this.setState({
                posts: posts,
                total_pages: response.total_pages,
                current_page: response.current_page
            })
        });

        ajax.fail(() => this.setState({error: 'Something went wrong while loading the posts. Try refresh the page'}));
        ajax.always(() => this.setState({loading: false}))
    }

    createPost(title, text) {
        this.setState({loading: true});

        let ajax = jQuery.post('/posts', {post: {title: title, text: text}});

        ajax.done(({data}) => {
            let posts = this.state.posts.slice();
            posts.unshift(data);
            this.setState({posts: posts})
        }).fail((data) => {
            this.setState({error: data})
        }).always(() => {
            this.setState({loading: false});
        });
    }

    destroyPost(post) {
        let ajax = jQuery.ajax({
            url: `/posts/${post.id}`,
            type: 'DELETE',
            dataType: 'json'
        });

        ajax.done((response) => {
            let posts = this.state.posts.filter((post) => {
                return post.id != response.post;
            });
            this.setState({posts: posts, message: response.status});
        });

        ajax.fail((response) => {
            this.setState({message: response.status, messageStatus: false})
        })
    }

    loadMorePosts() {
        console.log('clicked');
    }

    render() {
        let posts = this.state.posts.map((post, i) => {
            return <Post key={i} post={post} user={this.props.user} auth={this.props.auth}
                         destroyPost={this.destroyPost}/>
        });
        let createPost = (this.props.user == this.props.auth) ? <CreatePost createPost={this.createPost}/> : '';

        let loading = (
            <div className="loading-posts-spinner">
                <i className="fa fa-spinner fa-spin fa-3x fa-fw font-size-24"/>
                <span className="sr-only">Loading...</span>
            </div>
        );
        if (!this.state.error)
            if (!this.state.posts.length)
                return (
                    <div>
                        <StatusAlerts message={this.state.message} status={this.state.messageStatus}/>
                        <div className="alert alert-info">
                            Posts not found.
                        </div>
                        {createPost}
                    </div>
                );
            else
                return (
                    <div>
                        <StatusAlerts message={this.state.message} status={this.state.messageStatus}/>
                        <div id="user_posts_list">
                            {posts}
                            <LoadPostsBtn total_pages={this.state.total_pages} current_page={this.state.current_page}
                                          getPosts={this.getPosts}/>
                        </div>
                        {(this.state.loading) ? loading : ''}
                        {createPost}
                    </div>
                );

        else
            return (
                <div>
                    <div className="alert alert-danger">
                        {this.state.error}
                    </div>
                    {createPost}
                </div>
            );
    }
}
Posts.defaultProps = {
    posts: [],
    error: null
};
