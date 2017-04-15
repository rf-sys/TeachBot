class ShareLessonButtons extends React.Component {
    constructor(props) {
        super(props);
        this.share_url = $('meta[name=lesson_url]').attr("content");
        this.title = $('meta[name=lesson_title]').attr("content");
        this.description = $('meta[name=lesson_description]').attr("content");
        this.poster = $('meta[name=lesson_poster]').attr("content");
    }

    facebookButton() {
        return (
            <a className="btn fb-btn"
               href={`https://www.facebook.com/sharer/sharer.php?u=${this.share_url}&src=sdkpreparse`}
               target="_blank">
                <i className="fa fa-facebook-official" aria-hidden="true"/>
                &nbsp;Facebook
            </a>
        )
    }

    twitterButton() {
        return (
            <a className="btn btn-outline-primary"
               href={`https://twitter.com/intent/tweet?text=${this.title}&url=${this.share_url}`}
               target="_blank">
                <i className="fa fa-twitter" aria-hidden="true"/>
                &nbsp;Twitter
            </a>
        )
    }

    vkButton() {
        return (
            <a className="btn vk-btn"
               href={`https://vk.com/share.php?url=${this.share_url}&title=${this.title}&description=${this.description}&image=${this.poster}`}
               target="_blank">
                <i className="fa fa-vk" aria-hidden="true"/>
                &nbsp;Vk
            </a>
        )
    }

    render() {
        return (
            <ul className="list-inline text-right">
                <li className="list-inline-item">
                    {this.facebookButton()}
                </li>
                <li className="list-inline-item">
                    {this.twitterButton()}
                </li>
                <li className="list-inline-item">
                    {this.vkButton()}
                </li>

            </ul>
        )
    }

}