class CreatePost extends React.Component {
    constructor(props) {
        super(props);
        this.state = {title: '', text: '', show: false}
    }

    sendPost(e) {
        e.preventDefault();
        this.props.createPost(this.state.title, this.state.text);

        this.setState({title: '', text: ''})
    }

    changeTitle(event) {
        this.setState({title: event.target.value})
    }

    changeText(event) {
        this.setState({text: event.target.value})
    }

    showForm() {
        this.setState({show: true})
    }

    hideForm() {
        this.setState({show: false})
    }

    render() {

        let form = (
            <form id="new_post" onSubmit={this.sendPost.bind(this)}>
                <div className="form-group">
                    <label htmlFor="new_post_title">Title:</label>
                    <input type="text" id="new_post_title" className="form-control" placeholder="Title of your post"
                           required maxLength="30"
                           onChange={this.changeTitle.bind(this)} value={this.state.title}/>
                </div>
                <div className="form-group">
                    <label htmlFor="new_post_text">Content:</label>
                    <textarea id="new_post_text" className="form-control" placeholder="Content of your post"
                              required maxLength="255"
                              onChange={this.changeText.bind(this)} value={this.state.text}/>
                </div>
                <p><button className="btn btn-outline-info">Create Post</button></p>
                
                <button className="btn btn-block btn-outline-secondary" type="button"
                        onClick={this.hideForm.bind(this)}>
                    Hide form
                </button>
            </form>
        );

        let button = <button className="btn btn-block btn-outline-info" type="button"
                             onClick={this.showForm.bind(this)}>
            Show form
        </button>;

        let margin = {
            marginBottom: '15px'
        };

        return (
            <div style={margin}>
                {(this.state.show) ? form : button}
            </div>
        )

    }
}