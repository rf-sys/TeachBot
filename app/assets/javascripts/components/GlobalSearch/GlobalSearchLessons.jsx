class GlobalSearchLessons extends React.Component {
    constructor(props) {
        super(props);
    }

    renderLessons() {
        let lessons = this.props.lessons;

        return lessons.map((lesson) => {
            return <GlobalSearchLesson key={lesson.id} lesson={lesson}/>
        });
    }

    render() {
        return (
            <div>
                <div className="bg-primary text-white list-group-item round-0">Lessons</div>
                <div className="list-group">
                    {this.props.lessons.length ? this.renderLessons() : null}
                </div>
            </div>
        )
    }
}

GlobalSearchLessons.propTypes = {
    lessons: React.PropTypes.array
};