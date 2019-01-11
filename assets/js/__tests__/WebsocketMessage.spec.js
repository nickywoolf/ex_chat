import { mount } from "@vue/test-utils"
import WebsocketMessage from "@/WebsocketMessage.vue"

const slot = [
    '<div>',
    '',
    '<template v-if="props.message.success">success!</template>',
    '',
    '<template v-else>error!</template>',
    '',
    '<template v-if="props.message.errors.length == 0">no errors</template>',
    '',
    '<template v-else>{{ props.message.errors.join(" ") }}</template>',
    '',
    '<template>command: {{ props.message.command }}</template>',
    '',
    '<template>room: {{ props.message.room }}</template>',
    '',
    '<template v-if="props.message.body">message: {{ props.message.body }}</template>',
    '',
    '</div>'
].join('')

describe("WebsocketMessage.vue", () => {
    it("converts room created message to object", () => {
        const wrapper = mount(WebsocketMessage, {
            propsData: {
                originalMessage: { success: "ChatRoom has been created!" }
            },
            scopedSlots: { default: slot }
        })

        expect(wrapper.html()).toBe([
            '<div>',
            'success!',
            'no errors',
            'command: create',
            'room: ChatRoom',
            'message: ChatRoom has been created!',
            '</div>'
        ].join(''))
    })

    it("converts room exists error to object", () => {
        const wrapper = mount(WebsocketMessage, {
            propsData: {
                originalMessage: { error: "ChatRoom already exists" }
            },
            scopedSlots: { default: slot }
        })

        expect(wrapper.html()).toBe([
            '<div>',
            'error!',
            'ChatRoom already exists',
            'command: create',
            'room: ChatRoom',
            '<!---->',
            '</div>'
        ].join(''))
    })

    it("converts welcome message to object", () => {
        const wrapper = mount(WebsocketMessage, {
            propsData: {
                originalMessage: {
                    room: "ChatRoom",
                    message: "welcome to the ChatRoom chat room, username"
                }
            },
            scopedSlots: { default: slot }
        })


        expect(wrapper.html()).toBe([
            '<div>',
            'success!',
            'no errors',
            'command: join',
            'room: ChatRoom',
            'message: welcome to the ChatRoom chat room, username',
            '</div>'
        ].join(''))
    })

    it("converts already joined error to object", () => {
        const wrapper = mount(WebsocketMessage, {
            propsData: {
                originalMessage: { error: "you already joined the ChatRoom room!" }
            },
            scopedSlots: { default: slot }
        })


        expect(wrapper.html()).toBe([
            '<div>',
            'error!',
            'you already joined the ChatRoom room!',
            'command: join',
            'room: ChatRoom',
            '<!---->',
            '</div>'
        ].join(''))
    })
})