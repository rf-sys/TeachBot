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
            <a href="#" className="card-link text-danger" onClick={this.destroy}>Delete</a>
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

            /*
             <div className="list-group-item list-group-item-action flex-column align-items-start">
             <div className="d-flex w-100 justify-content-between">
             <h5 className="mb-1">{this.props.course.title}</h5>
             <small>
             <a href={`/courses/${this.props.course.slug}`} className="btn btn-sm btn-outline-info">
             Visit course
             </a>
             {this.belongsToUser() ? delete_button : null}
             </small>
             </div>

             <p className="mb-1">
             {this.props.course.description}
             </p>
             </div>
             */
        )
    }
}

UserCourse.propTypes = {
    course: React.PropTypes.object, // subscription == course
    user: React.PropTypes.number, // target user id
    current_user: React.PropTypes.number, // auth user id
    destroy: React.PropTypes.func // parent unsubscribe method
};