class Posts extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            posts: [],
            errors: [],
            loading: false,
            total_pages: null,
            current_page: null
        };

        this.createPost = this.createPost.bind(this);
        this.getPosts = this.getPosts.bind(this);
        this.destroyPost = this.destroyPost.bind(this);
    }

    componentDidMount() {
        this.getPosts()
    }

    getPosts(page = 1) {
        this.setState({loading: true});

        let ajax = jQuery.get(`/users/${this.props.user}/posts?page=${page}`,
            /**
             * @param {{ total_pages: number, current_page: number, posts: array }} response
             */
            (response) => {


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

        ajax.fail(() => this.setState({errors: ['Something went wrong while loading the posts. Try refresh the page']}));
        ajax.always(() => this.setState({loading: false}))
    }

    createPost(title, text) {
        this.setState({loading: true});

        let ajax = jQuery.post('/posts', {post: {title: title, text: text}});

        ajax.done(
            /**
             * @param {Object} data - created post json data
             */
            ({data}) => {
                let posts = this.state.posts.slice();
                posts.unshift(data);
                this.setState({posts: posts})
            }).fail((data) => {
            this.setState({errors: data.responseJSON.errors})
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
            this.setState({errors: response.responseJSON.errors})
        })
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
        if (!this.state.posts.length)
            return (
                <div>
                    <div className="text-center">
                        No posts
                    </div>
                    <hr/>
                    <StatusAlerts errors={this.state.errors} />
                    {createPost}
                </div>
            );
        else
            return (
                <div>
                    <div id="user_posts_list">
                        {posts}
                        <LoadPostsBtn total_pages={this.state.total_pages} current_page={this.state.current_page}
                                      getPosts={this.getPosts}/>
                    </div>
                    {(this.state.loading) ? loading : ''}
                    <hr/>
                    <StatusAlerts errors={this.state.errors} />
                    {createPost}
                </div>
            );
    }
}
Posts.defaultProps = {
    posts: [],
    error: null
};
