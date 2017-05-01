// define a mixin object
const mixin = {

    mounted() {
        let el = this.$refs.click_outside_el;


        $(document).bind(`click.clickOutside.${el.id}`, e => {
            if (!el.contains(e.target)) {
                this.clickOutside();
            }
        });
    },

    beforeDestroy() {
        let el = this.$refs.click_outside_el;

        $(document).unbind(`click.clickOutside.${el.id}`);
    }

};

export default mixin;