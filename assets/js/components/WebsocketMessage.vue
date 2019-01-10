<script>
export default {
    props: ["originalMessage"],
    render() {
        return this.$scopedSlots.default({
            message: {
                success: true,
                command: "create",
                room: "a room",
                errors: []
            }
        });
    }
};
</script>