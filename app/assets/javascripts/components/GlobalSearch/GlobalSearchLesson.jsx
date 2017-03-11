class GlobalSearchLesson extends React.Component {
    constructor(props) {
        super(props);
        this.courseReference = this.courseReference.bind(this);
        this.redirectToLesson = this.redirectToLesson.bind(this);

    }


    courseReference() {
        let course = this.props.lesson.course;
        return <a href={`/courses/${course.slug}`}>{course.title}</a>
    }

    redirectToLesson() {
        let lesson = this.props.lesson;
        return Turbolinks.visit(`/courses/${lesson.course.slug}/lessons/${lesson.slug}`);
    }

    render() {
        let lesson = this.props.lesson;
        return (
            <div onClick={this.redirectToLesson} style={{cursor: 'pointer'}}
               className="list-group-item list-group-item-action flex-column align-items-start round-0">
                <div className="d-flex w-100 justify-content-between">
                    <h5 className="mb-1">{lesson.title}</h5>
                    <small>{moment(lesson.updated_at).format('LLL')}</small>
                </div>
                <p className="mb-1">{lesson.description}</p>
                <small>Course: {this.courseReference()}</small>
            </div>
        )
    }
}

GlobalSearchLesson.propTypes = {
    lesson: React.PropTypes.object
};