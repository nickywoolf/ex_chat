<script>
export default {
    data: () => ({
        uri: null,
        websocket: null,
        open: null,
        message: null,
        error: null
    }),
    created() {
        this.createUri();
        this.connect();
        this.addCallbacks();
    },
    methods: {
        addCallbacks() {
            this.websocket.onopen = event => (this.open = true);
            this.websocket.onclose = event => (this.open = false);

            this.websocket.onmessage = message => {
                this.message = JSON.parse(message.data);
            };

            this.websocket.onerror = error => {
                this.error = JSON.parse(error.data);
            };
        },
        connect() {
            this.websocket = new WebSocket(this.uri);
        },
        createUri() {
            const query = new URLSearchParams(location.search);
            const accessToken = query.get("access_token");
            this.uri = `ws://${location.host}/chat?access_token=${accessToken}`;
        }
    },
    render() {
        return this.$scopedSlots.default({
            send: message => this.websocket.send(JSON.stringify(message)),
            open: this.open,
            message: this.message,
            error: this.error
        });
    }
};
</script>