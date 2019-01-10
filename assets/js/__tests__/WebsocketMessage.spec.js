import { mount } from "@vue/test-utils"
import WebsocketMessage from "@/WebsocketMessage.vue"

describe("WebsocketMessage.vue", () => {
    const slot = [
        '<div>',
        '<p v-if="props.message.success">success!</p>',
        '<p v-if="props.message.errors.length == 0">no errors</p>',
        '<p v-else>{{ props.message.errors.join(" ") }}</p>',
        '<p>{{ props.message.command }}, {{ props.message.room }}</p>',
        '</div>'
    ].join('')

    it("converts room created message to object", () => {
        const wrapper = mount(WebsocketMessage, {
            propsData: { originalMessage: { success: "a room has been created!" } },
            scopedSlots: { default: slot }
        })

        expect(wrapper.html()).toBe([
            '<div>',
            '<p>success!</p>',
            '<p>no errors</p>',
            '<p>create, a room</p>',
            '</div>'
        ].join(''))
    })

    it("converts room exists error to object", () => {
        const wrapper = mount(WebsocketMessage, {
            propsData: { originalMessage: { error: "a room already exists" } },
            scopedSlots: { default: slot }
        })

        expect(wrapper.html()).toBe([
            '<div>',
            '<!---->',
            '<p>already exists</p>',
            '<p>create, a room</p>',
            '</div>'
        ].join(''))
    })
})