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
                const create = /^(.*) already exists$/;
                const joined = /^you already joined the (.*) room!$/;
                const unexisting = /^(.*) does not exists$/;

                let command;
                let room;
                let errors = [];

                if (create.test(this.originalMessage.error)) {
                    const match = this.originalMessage.error.match(create);
                    command = "create";
                    room = match[1];
                    errors = [this.originalMessage.error];
                }

                if (joined.test(this.originalMessage.error)) {
                    const match = this.originalMessage.error.match(joined);
                    command = "join";
                    room = match[1];
                    errors = [this.originalMessage.error];
                }

                if (unexisting.test(this.originalMessage.error)) {
                    const match = this.originalMessage.error.match(unexisting);
                    command = "join";
                    room = match[1];
                    errors = [this.originalMessage.error];
                }

                return {
                    success: false,
                    command: command,
                    room: room,
                    body: false,
                    errors: errors
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