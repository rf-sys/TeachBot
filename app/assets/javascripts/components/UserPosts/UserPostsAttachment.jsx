class UserPostsAttachment extends React.Component {
    constructor(props) {
        super(props);
        this.createMarkup = this.createMarkup.bind(this);
    }

    createMarkup() {
        return {__html: this.props.attachment.template};
    }

    render() {
        return <div dangerouslySetInnerHTML={this.createMarkup()}/>
    }
}