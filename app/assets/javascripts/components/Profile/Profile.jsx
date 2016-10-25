import App from './App.jsx'

var Profile = React.createClass({
    render() {
        return (
            <App user={this.props.user} />
        )
    }
});
Profile.getDefaultProps = {
    user: {}
};

export default Profile