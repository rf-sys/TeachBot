class UserCourses extends React.Component {
    constructor(props) {
        super(props);
        this.state = {courses: [], current_page: 0, total_pages: 1, loading: true};
        this.getCourses = this.getCourses.bind(this);
        this.destroy = this.destroy.bind(this);
        this.renderCourses = this.renderCourses.bind(this);
    }

    componentDidMount() {
        this.getCourses();
    }

    getCourses(page = 1) {
        let ajax = $.getJSON(`/users/${this.props.user}/courses?page=${page}`);

        ajax.done(
            /**
             * @param {{courses: Array, current_page: Number, total_pages: Number}} response
             */
            (response) => {
                this.setState({
                    courses: response.courses,
                    current_page: response.current_page,
                    total_pages: response.total_pages,
                    loading: false
                })
            });
    }

    destroy(course_id) {
        let ajax = $.ajax({
            url: `/users/${this.props.user}/courses/${course_id}`,
            method: 'DELETE',
            dataType: 'json'
        });

        ajax.done(() => {
            // it helps us to regenerate not only list of courses but pages either
            this.getCourses();
        });
    }

    renderCourses() {
        let courses_chunk = _.chunk(this.state.courses, 2);


        return courses_chunk.map((chunk, i) => {
            return (
                <div className="card-deck" key={i}>
                    {chunk.map((course) => {
                        return <UserCourse course={course} key={course.id}
                                           user={this.props.user} current_user={this.props.current_user}
                                           destroy={this.destroy}/>
                    })}
                </div>
            )
        });
    }

    render() {
        let not_found = (
            <div className="text-center">
                <h2>Courses not found</h2>
                {this.props.current_user == this.props.user ? <a href="/courses/new">Create a new one</a> : null}
            </div>
        );

        let loading = (
            <div className="text-center">
                <i className="fa fa-spinner fa-spin fa-3x fa-fw"/>
                <span className="sr-only">Loading...</span>
            </div>
        );

        let content = (
            <div>
                {!_.isEmpty(this.state.courses) ? this.renderCourses() : not_found}
                <Paginator current_page={this.state.current_page}
                           total_pages={this.state.total_pages}
                           action={this.getCourses}
                />
            </div>
        );
        return (
            <div>
                {this.state.loading ? loading : content}
            </div>
        )
    }
}

UserCourses.propTypes = {
    user: React.PropTypes.number, // target user id
    current_user: React.PropTypes.number // auth user id
};