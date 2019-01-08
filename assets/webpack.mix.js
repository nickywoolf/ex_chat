const mix = require("laravel-mix")

require("laravel-mix-tailwind")
require("laravel-mix-purgecss")

mix.setPublicPath("../priv/static")
    .js("js/chat.js", "js/chat.js")
    .postCss("css/chat.css", "css/chat.css")
    .tailwind()
    .purgeCss({
        enabled: mix.inProduction(),
        globs: [
            path.join(__dirname, "js/components/*.vue"),
            path.join(__dirname, "../priv/static/chat.html")
        ],
        extensions: ["html", "vue"],
    })

if (mix.inProduction()) {
    mix.version()
}