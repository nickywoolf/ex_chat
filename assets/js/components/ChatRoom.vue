<template>
    <websocket-connection>
        <websocket-message slot-scope="websocket" :original-message="websocket.message">
            <div slot-scope="{ message }">
                <p>{{ message.command}}</p>
                <create-room :websocket="websocket">
                    <div class="mb-3" slot-scope="{ inputProps, inputEvents, buttonEvents }">
                        <input
                            type="text"
                            class="border mr-2 px-4 py-2 rounded-sm"
                            v-bind="inputProps"
                            v-on="inputEvents"
                        >
                        <button
                            class="bg-blue px-4 py-2 rounded-sm text-white"
                            v-on="buttonEvents"
                        >Create room</button>
                    </div>
                </create-room>

                <button
                    @click="websocket.send({command: 'join', room: 'default'})"
                    class="bg-blue px-4 py-2 rounded-sm text-white"
                >Join room</button>
                
                <button
                    @click="websocket.send({room: 'default', message: 'a new message'})"
                    class="bg-blue px-4 py-2 rounded-sm text-white"
                >Send Message</button>
            </div>
        </websocket-message>
    </websocket-connection>
</template>

<script>
import CreateRoom from "./CreateRoom.vue";
import WebsocketConnection from "./WebsocketConnection.vue";
import WebsocketMessage from "./WebsocketMessage.vue";

export default {
    components: {
        CreateRoom,
        WebsocketConnection,
        WebsocketMessage
    }
};
</script>