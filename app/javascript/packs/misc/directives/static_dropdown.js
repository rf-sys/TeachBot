// uses target element - "static_dropdown" ref
// returns callback (clickOutside) if click outside the target and its childs
const directive = {

    /**
     * @param {Node} el - dropdown instance (element with "dropdown-menu" class)
     */
    bind(el) {
        $(el).click(function (e) {
            e.stopPropagation();
        });
    },

    /**
     * @param {Node} el
     */
    unbind(el) {
        $(el).unbind();
    }

};

export default directive;