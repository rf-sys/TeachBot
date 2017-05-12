// uses target element - "click_outside_el" ref
// returns callback (clickOutside) if click outside the target and its childs
let event_uid, event_name;

const directive = {
    /**
     * @param {Node} el
     * @param {Object} binding
     * @param {function} binding.value - callback
     */
    bind(el, binding) {
        event_uid = new Date().getTime();
        event_name = `click.clickOutside.${event_uid}`;

        $(document).bind(event_name, e => {
            if (!el.contains(e.target)) {
                binding.value();
            }
        });
    },

    unbind() {
        $(document).unbind(event_name);
    }

};

export default directive