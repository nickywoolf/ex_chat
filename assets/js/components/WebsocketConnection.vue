<script>
export default {
    data: () => ({
        uri: null,
        websocket: null
    }),
    created() {
        this.initializeData();
        this.connect();
    },
    methods: {
        connect() {
            this.websocket = new WebSocket(this.uri);

            this.websocket.onopen = event => {
                // do something...
            };

            this.websocket.onclose = event => {
                // do something...
            };

            this.websocket.onmessage = message => {
                // do something...
            };

            this.websocket.onerror = error => {
                // do something...
            };
        },
        initializeData() {
            const query = new URLSearchParams(location.search);
            const accessToken = query.get("access_token");
            this.uri = `ws://${location.host}/chat?access_token=${accessToken}`;
        }
    },
    render() {
        return this.$scopedSlots.default({
            send: message => this.websocket.send(JSON.stringify(message))
        });
    }
};
</script>