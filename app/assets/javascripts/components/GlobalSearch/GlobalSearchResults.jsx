class GlobalSearchResults extends React.Component {
    constructor(props) {
        super(props);
    }

    renderCourses() {
        let courses = this.props.data.courses || [];
        return courses.length ? <GlobalSearchCourses courses={this.props.data.courses}/> : null
    }

    renderLessons() {
        let lessons = this.props.data.lessons || [];
        return lessons.length ? <GlobalSearchLessons lessons={this.props.data.lessons}/> : null
    }

    renderUsers() {
        let users = this.props.data.users || [];
        return users.length ? <GlobalSearchUsers users={this.props.data.users}/> : null
    }

    renderEmptyResponse() {
        return (
            <div className="card">
                <div className="card-block text-center">
                    No results&nbsp;
                    <i className="fa fa-eye-slash" aria-hidden="true"/>
                </div>
            </div>
        )
    }

    renderData() {
        return (
            <div>
                {this.renderCourses()}
                {this.renderLessons()}
                {this.renderUsers()}
            </div>
        )
    }

    emptyResponse() {
        return this.props.emptyResponse;
    }

    render() {
        return (
            <div className="search_result_panel_wrapper rounded-0" id="global_search_result_panel">
                {!this.props.atLeastOnePresent && this.emptyResponse() ? this.renderEmptyResponse() : null}
                {this.props.atLeastOnePresent ? this.renderData() : null}
            </div>
        )

    }
}

GlobalSearchResults.propTypes = {
    data: React.PropTypes.shape({
        courses: React.PropTypes.array,
        lessons: React.PropTypes.array
    }),

    text: React.PropTypes.string
};