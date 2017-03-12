class GlobalSearch extends React.Component {
    constructor(props) {
        super(props);
        this.state = {text: '', data: {}, loading: false, emptyResponse: false};
        this.triggerChangeInput = this.triggerChangeInput.bind(this);
        this.search = _.debounce(this.search.bind(this), 300);
        this.atLeastOnePresent = this.atLeastOnePresent.bind(this);
    }

    componentDidMount() {
        $(document)
            .unbind('global_search_result_panel:hide')
            .bind('global_search_result_panel:hide', () => {
            this.setState({data: {}, emptyResponse: false});
        });
    }

    search(text) {

        this.setLoadingStatus(true);

        let request = this.request(text);

        request.then((response) => {
            this.setState({data: response});

            if (this.atLeastOnePresent() || !this.state.text.length)
                this.setState({emptyResponse: false});
            else
                this.setState({emptyResponse: true});

        });

        request.fail((response) => {
        });

        request.always(() => this.setLoadingStatus(false));
    }

    setLoadingStatus(bool) {
        this.setState({loading: bool});
    }

    triggerChangeInput(e) {
        let text = e.target.value;
        this.setState({text: text});

        this.search(text);
    }

    request(text) {
        return $.get('/search', {text: text});
    }

    atLeastOnePresent() {
        let courses = this.state.data.courses || [];
        let lessons = this.state.data.lessons || [];
        let users = this.state.data.users || [];

        return (courses.length + lessons.length + users.length) > 0
    }

    render() {
        return (
            <div className="input_wrapper">
                <input type="search" className="form-control input"
                       placeholder="Find in courses and lessons..."
                       onChange={this.triggerChangeInput}/>
                <GlobalSearchLoadingIcon loading={this.state.loading}/>
                <GlobalSearchResults data={this.state.data} text={this.state.text}
                                     atLeastOnePresent={this.atLeastOnePresent()}
                                     emptyResponse={this.state.emptyResponse}/>
            </div>
        )
    }
}