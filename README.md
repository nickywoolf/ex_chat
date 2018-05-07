# ExChat

This is a simple chat server built in Elixir with the goal to show a real life application of Websockets.

![the sketch](/sketch.png?raw=true)

## Features roadmap

- Multiple Rooms support
- A Websockets server implementation so that we can support web clients
- A minimal frontend to allow users to subscribe to each room, sending messages and receiving messages

## Run tests

```
$ mix deps.get
$ mix test
```

## Run application

```
$ mix deps.get
$ iex -S mix
```

_Check out the chat web client at `http://localhost:4000/chat.html`_

## Scratchpad

### DOING

- think to separate the two actions `create chatroom` and `join chatroom` (at the moment the chatroom creation happens when a client try to join an unexisting chatroom, look at the `ChatRooms.create_and_join_chatroom/3` function)

### TODO

- handle the welcome message in the `ChatRoom` itself and not in the `chatroom_websocket_handler`
- promote the `ChatRooms` to be a `Supervisor` instead of being a `GenServer`
- think to rename the websocket endpoint (`ws://localhost:4000/room`), maybe `/chat` or others
- As a client I want to connect with my username so that others can see the name of the user who send the messages
- BUG: Avoid that a subscribed client can subscribe twice to the same room
- Unsubscribe a client to receive messages once it leave the chat
- improve the way we make assertions on received messages (e.g. assert_receive wants pattern match and not functions or variables)
- maybe `ExChat.Web.Router` is not a good name for the web sockets delivery mechanism (maybe `Web.WebSocket`)
- try to write some acceptance test (e.g. gherkin/cucumber for elixir? or use ExUnit?)
- find a way to distribute the Chat, in order to use more than one nodes

### DONE

- Handle multiple chat rooms
- adapt the UI to handle the room name
- handle the chat room creation when client wants to join to an unexisting chat room
- rename `subscriber` to `client` in `ChatRooms`
- change the format of the response for other tests (add the room name)
- Rename `web.http` to `web.router`
- Remove the `/echo` endpoint just because it is no longer needed
- Allow web clients to receive messages
- Allow web clients to write and send messages
  - We have to create a better web UI to allows user to write and send messages
- Replace the `plug-web-socket` with the default `cowboy_websocket_handler`
- Allow web clients to join a chatroom
- How to test the websocket endpoint in Elixir
- Put `how to run tests` and `how to start application` in the `README.md`
- Start the application
- Rename the test folder `exchat` to `ex_chat`
- As a client I can subscribe to a chat room so that I can receive all the messages sent
