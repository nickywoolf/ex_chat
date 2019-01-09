import Vue from "vue"
import ChatRoom from "./components/ChatRoom.vue"

Vue.component("chat-room", ChatRoom)

const app = new Vue({
    el: "#app"
})