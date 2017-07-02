class GlobalSearchUser extends React.Component {
    constructor(props) {
        super(props);
    }

    renderAvatar() {
        let avatar = this.props.user.avatar;
        return avatar ? <img src={avatar}/> : null
    }

    render() {
        let user = this.props.user;
        return (
            <a href={`/users/${user.slug}`} name={`gs_user_${user.slug}_link`}
               className="round-0 list-group-item list-group-item-action flex-column align-items-start">
                <div className="row align-items-center">
                    <div className="col-md-2">
                        {this.renderAvatar()}
                    </div>
                    <div className="col-md-10">
                        <h5 className="mb-1">{user.username}</h5>
                    </div>
                </div>
            </a>
        )
    }
}

GlobalSearchUser.propTypes = {
    user: React.PropTypes.object
};