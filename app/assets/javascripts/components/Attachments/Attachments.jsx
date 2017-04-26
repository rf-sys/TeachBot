class Attachments extends React.Component {
    constructor(props) {
        super(props);
        this.state = {attachments: [], loaded_urls_once: [], loading: false};
        this.url_format = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/;

        this.checkTextOnReferences = _.debounce(this.checkTextOnReferences.bind(this), 500);
        this.setAttachment = this.setAttachment.bind(this);
        this.addAttachmentToPreviewContent = this.addAttachmentToPreviewContent.bind(this);
        this.existingUrlInAttachments = this.existingUrlInAttachments.bind(this);
        this.addUrlToLoadedOnce = this.addUrlToLoadedOnce.bind(this);
        this.loadedOnce = this.loadedOnce.bind(this);
        this.addEventListenersToAttachment = this.addEventListenersToAttachment.bind(this);
        this.removeAttachment = this.removeAttachment.bind(this);
        this.updateAttachments = this.updateAttachments.bind(this);
        this.changeAttachment = this.changeAttachment.bind(this);
        this.addAttachment = this.addAttachment.bind(this);
        this.clearAll = this.clearAll.bind(this);
    }

    componentDidMount() {
        $(document).on('attachments:clearAll', () => {
            return this.clearAll();
        });
    }

    componentWillReceiveProps(nextProps) {
        // we can get new attachments from outside
        // (to provide more flexibility and not only fetch url from text)
        if (nextProps.attachment)
            this.addAttachment(nextProps.attachment);
    }

    componentDidUpdate(prevProps) {
        // check text on new urls only if text has been changed and not empty
        if (this.props.text && (prevProps.text !== this.props.text))
            this.checkTextOnReferences();
    }

    /**
     * Extract url from the text with regex
     * @return {string|null}
     */
    getUrlFromText() {
        let url = this.props.text.match(this.url_format);

        return url ? url[0] : null;
    }

    /**
     * Check provided url is in attachments list already
     * @param url
     * @return {boolean}
     */
    existingUrlInAttachments(url) {
        let present_urls = _.map(this.state.attachments, 'url');
        return _.includes(present_urls, url);
    }


    /**
     * Add url to loaded once to prevent repeat loading the same url
     * @param {string} url - url of the attachment
     */
    addUrlToLoadedOnce(url) {
        let urls = this.state.loaded_urls_once;
        urls.push(url);

        this.setState({loaded_urls_once: urls});
    }

    /**
     * Check if url has been loaded before to prevent repeat loading the same url
     * @param {string} url - url of the attachment
     * @return {boolean}
     */
    loadedOnce(url) {
        return _.includes(this.state.loaded_urls_once, url);
    }

    /**
     * Add event listeners to new attachment template
     * @param attachment
     */
    addEventListenersToAttachment(attachment) {

        let attachment_el = $(`div[data-attachment-id='${attachment.data.id}']`);

        if (attachment.data.type === 'image') {
            let delete_image_button = attachment_el.find("[data-name='deleteImageButton']");
            delete_image_button.click(() => {
                attachment_el.remove();
                this.removeAttachment(attachment);
            });
        }

        if (attachment.data.type === 'link') {
            let delete_link_button = attachment_el.find("[data-name='deleteLinkButton']");
            let delete_image_button = attachment_el.find("[data-name='deleteLinkImageButton']");
            let link_image = attachment_el.find("[data-name='linkImage']");
            let link_title = attachment_el.find("[data-name='linkTitle']");

            delete_link_button.click(() => {
                attachment_el.remove();
                this.removeAttachment(attachment);
            });

            delete_image_button.click(() => {
                link_image.remove();
                delete_image_button.remove();
                this.changeAttachment(attachment, 'image', null);
            });

            let link_title_editor = new wysihtml5.Editor(link_title[0], {
                autoLink: false,
                handleTabKey: false,
                handleTables: false
            });

            link_title_editor.on('change', () => {
                return this.changeAttachment(attachment, 'title', _.trim(link_title.text()));
            });
        }
    }

    /**
     * Find url in text
     */
    checkTextOnReferences() {
        let url = this.getUrlFromText();

        if (url && !this.existingUrlInAttachments(url) && !this.loadedOnce(url)) {
            this.addUrlToLoadedOnce(url);
            this.loadAttachment(url);
        }

    }

    /**
     * Update local list of attachments
     * Update parent list of attachments (form)
     * @param {Object[]} attachments
     */
    updateAttachments(attachments) {
        this.setState({attachments: attachments});

        // update parent component
        this.props.setAttachments(attachments);
    }

    /**
     * dd attachment to attachments list
     * @param {object} attachment
     */
    setAttachment(attachment) {
        let attachments = this.state.attachments;

        attachments.push(attachment);

        this.setState({attachments: attachments});

        this.updateAttachments(attachments);
    }

    /**
     * remove attachment from the list of attachments
     * @param {object} attachment
     */
    removeAttachment(attachment) {
        let attachments = _.filter(this.state.attachments, function (item) {
            return item.id !== attachment.data.id;
        });

        this.updateAttachments(attachments);
    }

    /**
     * Change key's value of the specific attachment
     * @param {object} attachment
     * @param {string} path - path to key to change
     * @param value - new value of the key
     */
    changeAttachment(attachment, path, value) {
        let attachments = _.forEach(this.state.attachments, function (item) {
            if (item.id === attachment.data.id)
                _.set(item, path, value);

            return item;
        });

        this.updateAttachments(attachments);
    }

    /**
     * prepends template, received from the server to preview block
     * @param {string} template - attachment template
     */
    addAttachmentToPreviewContent(template) {
        $(this.preview_content).prepend(template);
    }

    /**
     * Load attachment data and preview template from the server.
     * Add attachment to attachments list
     * Add attachment template to preview block
     * Add event listeners to added to the preview block template
     * Add url to loaded list to prevent repeat load the same url
     * @param {string} url - attachment url
     */
    loadAttachment(url) {
        this.setState({loading: true});
        let ajax = $.post('/attachment', {url: url});
        ajax.done((attachment) => {
            if (!_.isEmpty(attachment)) {
                this.setAttachment(attachment.data);
                this.addAttachmentToPreviewContent(attachment.template);
                this.addEventListenersToAttachment(attachment);
            }
        });

        ajax.always(() => this.setState({loading: false}));
    }

    /**
     * receive url (likely from outside component) to load template from the server
     * @param {string} url - attachment url
     */
    addAttachment(url) {
        /*
         check if:
         1. url present
         2. url has valid format
         3. url is not presented in attachments
         4. url has not been loaded once
         */
        if (url && this.url_format.test(url) && !this.existingUrlInAttachments(url) && !this.loadedOnce(url))
            this.loadAttachment(url);
    }

    clearAll() {
        // clear preview block
        $(this.preview_content).empty();
        // clear attachments list
        this.updateAttachments([]);
        // clear loaded url list
        this.setState({loaded_urls_once: []})
    }

    render() {
        return (
            <div>
                <AttachmentsLoading loading={this.state.loading}/>
                <div ref={(preview_content) => {
                    this.preview_content = preview_content;
                }}/>
            </div>

        )
    }
}

Attachments.PropTypes = {
    text: React.PropTypes.string,
    setAttachments: React.PropTypes.func, // pass attachments to parent
    attachment: React.PropTypes.object  // get new attachment from parent to load
};