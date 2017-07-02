class GlobalSearchCourses extends React.Component {
    constructor(props) {
        super(props);
    }

    renderCourses() {
        let courses = this.props.courses;

        return courses.map((course) => {
            return <GlobalSearchCourse key={course.id} course={course}/>
        });
    }

    render() {
        return (
            <div>
                <div className="bg-primary text-white list-group-item round-0">
                    Courses
                </div>
                <div className="list-group">
                    {this.props.courses.length ? this.renderCourses() : null}
                </div>
            </div>
        )
    }
}

GlobalSearchCourses.propTypes = {
    courses: React.PropTypes.array
};