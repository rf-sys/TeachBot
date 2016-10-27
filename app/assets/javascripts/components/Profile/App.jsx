import Modal from './Modal.jsx'

const App = React.createClass({
    render() {
        return (
            <div>
                <button className="btn btn-outline-primary btn-block"
                        data-toggle="modal" data-target="#profileModal">
                    Settings <i className="fa fa-cog" aria-hidden="true"></i>
                </button>

                <Modal user={this.props.user} />
            </div>
        )

    }
});

export default App