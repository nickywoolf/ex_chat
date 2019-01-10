<script>
export default {
    props: ["originalMessage"],
    computed: {
        message() {
            if (this.originalMessage.hasOwnProperty("success")) {
                return {
                    success: true,
                    command: "create",
                    room: "a room",
                    errors: []
                };
            } else {
                return {
                    success: false,
                    command: "create",
                    room: "a room",
                    errors: ["already exists"]
                };
            }
        }
    },
    render() {
        return this.$scopedSlots.default({
            message: this.message
        });
    }
};
</script>