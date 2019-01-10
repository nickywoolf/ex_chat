<script>
export default {
    props: ["websocket"],
    data: () => ({
        input: "",
        message: null
    }),
    watch: {
        "websocket.message"(val, oldVal) {
            this.message = val;
        }
    },
    methods: {
        createRoom() {
            this.websocket.send({ command: "create", room: this.input });
        }
    },
    render() {
        return this.$scopedSlots.default({
            inputProps: {
                value: this.input
            },
            inputEvents: {
                input: e => (this.input = e.target.value),
                keydown: e => {
                    if (e.key === "Enter") {
                        e.preventDefault();
                        this.createRoom();
                    }
                }
            },
            buttonEvents: {
                click: e => {
                    e.preventDefault();
                    this.createRoom();
                }
            }
        });
    }
};
</script>