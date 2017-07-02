class UserCourse extends React.Component {
    constructor(props) {
        super(props);
        this.destroy = this.destroy.bind(this);
    }

    destroy(e) {
        e.preventDefault();
        this.props.destroy(this.props.course.id);
    }

    belongsToUser() {
        return this.props.current_user && this.props.current_user == this.props.user;
    }


    render() {
        let delete_link = (
            <a href="#" className="card-link text-danger" onClick={this.destroy}
            data-confirm="Are you sure that you want to delete this course ?">Delete</a>
        );

        let type = `Access: ${this.props.course.public ? 'free' : 'limited (only for appointed participants)'}`;

        return (
            <div className="card animated fadeIn" style={{margin: '5px'}}>
                <div className="card-block">
                    <h4 className="card-title">{this.props.course.title}</h4>
                    <h6 className="card-subtitle mb-2 text-muted">{type}</h6>
                    <p className="card-text">
                        {this.props.course.description}
                    </p>
                    <a href={`/courses/${this.props.course.slug}`} className="card-link">Visit</a>

                    {this.belongsToUser() ? delete_link : null}
                </div>
            </div>
        )
    }
}

UserCourse.propTypes = {
    course: React.PropTypes.object, // subscription == course
    user: React.PropTypes.number, // target user id
    current_user: React.PropTypes.number, // auth user id
    destroy: React.PropTypes.func // parent unsubscribe method
};