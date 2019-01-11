<script>
export default {
    props: ["originalMessage"],
    computed: {
        message() {
            if (!this.originalMessage) {
                return;
            }

            if (this.originalMessage.success) {
                const match = this.originalMessage.success.match(
                    /^(.*) has been created!$/
                );

                return {
                    success: true,
                    command: "create",
                    room: match[1],
                    body: this.originalMessage.success,
                    errors: []
                };
            }

            if (this.originalMessage.error) {
                const match = this.originalMessage.error.match(
                    /^(.*) already exists$/
                );

                return {
                    success: false,
                    command: "create",
                    room: match[1],
                    body: false,
                    errors: [this.originalMessage.error]
                };
            }

            if (this.originalMessage.message) {
                const match = this.originalMessage.message.match(
                    /^welcome to the (.*) chat room, (.*)$/
                );

                return {
                    success: true,
                    command: "join",
                    room: this.originalMessage.room,
                    body: this.originalMessage.message,
                    errors: []
                };
            }

            return {
                success: false,
                command: "unkown",
                room: "unknown",
                errors: ["received some kind of message"]
            };
        }
    },
    render() {
        return this.$scopedSlots.default({
            message: this.message
        });
    }
};
</script>