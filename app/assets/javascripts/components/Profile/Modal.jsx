import EmailField from './parts/EmailField.jsx'
import UsernameField from './parts/UsernameField.jsx'
import AvatarField from './parts/AvatarField.jsx'
import ProfileAlerts from './parts/ProfileAlerts.jsx'

class Modal extends React.Component {
    constructor(props) {

        super(props);

        this.state = {
            username: props.user.username,
            email: props.user.email,
            avatar: null,

            responseData: [],
            responseSuccess: false
        };

        this.props = props;
    }

    changeUsername(val) {
        this.setState({username: val});
    }

    changeEmail(val) {
        this.setState({email: val});
    }

    changeAvatar(val) {
        this.setState({avatar: val});
    }

    resetResponseData() {
        this.setState({responseData: []})
    }

    SubmitForm(e) {

        e.preventDefault();

        var Form = new FormData();

        Form.append('username', this.state.username);
        Form.append('email', this.state.email);

        if (this.state.avatar)
            Form.append('avatar', this.state.avatar);


        console.log('/users/' + this.props.user.id);

        $.ajax({
            url: "/users/" + this.props.user.id,
            type: "PATCH",
            data: Form,
            contentType: false,
            processData: false,
            success: function (response) {
                this.setState({responseData: []});
                if (response.data) {
                    this.setState({responseData: [response.message], responseSuccess: true});

                    $("#user_username").text(response.data.username);
                    $("#header_user_link").text(response.data.username);
                    $("#user_email").text(response.data.email);

                    if (response.data.avatar) {
                        $("#user_avatar").attr('src', response.data.avatar + '?' + Math.random());
                    }
                }

            }.bind(this),
            error: function (response) {
                this.setState({responseData: []});
                this.setState({responseData: response.responseJSON.error, responseSuccess: false});
            }.bind(this)
        });

    }


    render() {
        var align = {
            textAlign: 'left'
        };
        var margin = {
            marginLeft: '5px'
        };
        var alert;
        if (this.state.responseData.length)
            alert = <ProfileAlerts
                list={this.state.responseData}
                success={this.state.responseSuccess}
                resetResponseData={this.resetResponseData.bind(this)}
            />;
        else
            alert = null;
        return (
            <div id="profileModal" className="modal fade" tabIndex="-1" role="dialog" aria-labelledby="gridModalLabel"
                 aria-hidden="true" style={align}>
                <div className="modal-dialog" role="document">
                    <div className="modal-content">
                        <div className="modal-header">
                            <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span
                                aria-hidden="true">&times;</span></button>
                            <h4 className="modal-title" id="gridModalLabel">Profile settings</h4>
                        </div>
                        <form onSubmit={this.SubmitForm.bind(this)} id="edit_user_form">
                            <div className="modal-body">
                                {alert}
                                <UsernameField changeUsername={this.changeUsername.bind(this)}
                                               username={this.props.user.username}/>
                                <EmailField changeEmail={this.changeEmail.bind(this)}
                                            email={this.props.user.email}/>
                                <AvatarField changeAvatar={this.changeAvatar.bind(this)}/>
                            </div>
                            <div className="modal-footer">
                                <button type="button" className="btn btn-secondary" data-dismiss="modal">Close</button>
                                <button type="submit" className="btn btn-primary" style={margin}>Save changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        )
    }

}

export default Modal