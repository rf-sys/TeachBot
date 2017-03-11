class GlobalSearchCourse extends React.Component {
    constructor(props) {
        super(props);
    }

    renderPoster() {
        let poster = this.props.course.poster;
        return poster ? <img src={poster}/> : null
    }

    render() {
        let course = this.props.course;
        return (
            <a href={`/courses/${course.slug}`}
               className="round-0 list-group-item list-group-item-action flex-column align-items-start">
                <div className="row align-items-center">
                    <div className="col-md-4">
                        {this.renderPoster()}
                    </div>
                    <div className="col-md-8">
                        <h5 className="mb-1">{course.title}</h5>
                        <small>{moment(course.updated_at).format('LLL')}</small>
                        <p className="mb-1">{course.description}</p>
                    </div>
                </div>
            </a>
        )
    }
}

GlobalSearchCourse.propTypes = {
    course: React.PropTypes.object
};