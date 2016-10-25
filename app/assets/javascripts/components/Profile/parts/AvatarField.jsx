class AvatarField extends React.Component {
    constructor(props) {
        super(props);

        this.props = props;

        this.state = {presence: false}
    }

    changeAvatar(evt) {

        var preview = document.getElementById('avatar_preview');

        var file = evt.target.files[0];

        var reader = new FileReader();

        reader.onloadend = function () {
            preview.src = reader.result;
        };

        if (file) {
            this.setState({presence: true});
            reader.readAsDataURL(file);

        } else {
            preview.src = "";
        }


        this.props.changeAvatar(file);

    }

    render() {

        var margin;


        if (this.state.presence == true)
            margin = {
                marginTop: '5px',
                display: 'block'
            };
        else
            margin = {
                marginTop: '5px',
                display: 'none'
            };


        return (
            <div className="form-group">
                <label htmlFor="profile_avatar" className="form-control-label">Avatar:</label>
                <input type="file" id="profile_avatar" className="form-control-file"
                       onChange={this.changeAvatar.bind(this)}
                />
                <img src="" height="200" alt="Image preview..." id="avatar_preview" style={margin}/>
            </div>
        )
    }
}

export default AvatarField