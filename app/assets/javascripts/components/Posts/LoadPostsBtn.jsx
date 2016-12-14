class LoadPostsBtn extends React.Component {
    constructor(props) {
        super(props);
        this.triggerLoadMorePosts = this.triggerLoadMorePosts.bind(this)
    }

    triggerLoadMorePosts() {
        this.props.getPosts(this.props.current_page + 1);
    }

    render() {
        if (this.props.current_page >= this.props.total_pages)
            return <div></div>;
        else
            return (
                <button className="btn btn-outline-primary btn-block" onClick={this.triggerLoadMorePosts}>
                    Load more posts
                </button>
            );
    }
}