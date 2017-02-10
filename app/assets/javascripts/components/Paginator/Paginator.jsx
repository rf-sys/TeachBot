class Paginator extends React.Component {
    constructor(props) {
        super(props);
        this.state = {pages: []};
        this.sendPage = this.sendPage.bind(this);
    }

    sendPage(e) {
        e.preventDefault();
        let page = e.target.dataset.page;
        if (this.props.current_page != page)
            this.props.action(page);
    }

    page(i) {
        return (
            <li className={`page-item ${this.props.current_page == i ? 'active' : ''}`} key={i}>
                <a className='page-link' href="#" onClick={this.sendPage} data-page={i}>
                    {i}
                </a>
            </li>
        )
    }

    generatePages() {
        if (this.props.total_pages > 1) {
            let pages = this.state.pages.slice();
            for (let i = 1; i <= this.props.total_pages; i++) {
                pages.push(this.page(i));
            }
            return pages;
        }
    }

    prevPage() {
        if (this.props.current_page > 1)
            return (
                <a className="page-link" href="#" onClick={this.sendPage} data-page={this.props.current_page - 1}>
                    Previous page
                </a>
            );
        else
            return null;

    }

    nextPage() {
        if (this.props.current_page < this.props.total_pages)
            return (
                <a className="page-link" href="#" onClick={this.sendPage} data-page={this.props.current_page + 1}>
                    Next page
                </a>
            );
        else
            return null;
    }

    render() {
        return (
            <nav>
                <ul className="pagination justify-content-center">
                    {this.prevPage()}
                    {this.generatePages()}
                    {this.nextPage()}
                </ul>
            </nav>
        )
    }
}

Paginator.propTypes = {
    current_page: React.PropTypes.number,
    total_pages: React.PropTypes.number,
    action: React.PropTypes.func // callback
};