defmodule ExChat.Web.WebSocketAcceptanceTest do
  use ExUnit.Case, async: true
  import WebSocketClient

  setup_all do
    Application.start :ranch
  end

  setup do
    start_supervised! ExChat.Application
    :ok
  end

  describe "As a User when I join the default chat room" do
    setup do
      ExChat.UserSessions.create("a-user")

      {:ok, ws_client} = connect_to "ws://localhost:4000/chat?access_token=A_USER_ACCESS_TOKEN", forward_to: self()
      send_as_text(ws_client, "{\"command\":\"join\"}")

      {:ok, ws_client: ws_client}
    end

    test "I want to receive a welcome message containing my name" do
      assert_receive "{\"room\":\"default\",\"message\":\"welcome to the default chat room, a-user!\"}"
    end
  end

  describe "when join the default chat room" do
    setup do
      {:ok, ws_client} = connect_to "ws://localhost:4000/chat", forward_to: self()
      send_as_text(ws_client, "{\"command\":\"join\"}")

      {:ok, ws_client: ws_client}
    end

    test "each message sent is received back", %{ws_client: ws_client} do
      send_as_text(ws_client, "{\"room\":\"default\",\"message\":\"Hello folks!\"}")

      assert_receive "{\"room\":\"default\",\"message\":\"Hello folks!\"}"
    end

    test "we receive all the messages sent by other clients" do
      {:ok, other_client} = connect_to "ws://localhost:4000/chat", forward_to: NullProcess.start
      send_as_text(other_client, "{\"command\":\"join\"}")

      send_as_text(other_client, "{\"room\":\"default\",\"message\":\"Hello from Twitch!\"}")

      assert_receive "{\"room\":\"default\",\"message\":\"Hello from Twitch!\"}"
    end
  end

  describe "when create a new chat room" do
    setup do
      {:ok, ws_client} = connect_to "ws://localhost:4000/chat", forward_to: self()
      send_as_text(ws_client, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")

      {:ok, ws_client: ws_client}
    end

    test "an error message is received if the room already exist", %{ws_client: ws_client} do
      send_as_text(ws_client, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")

      assert_receive "{\"error\":\"a_chat_room already exists\"}"
    end

    test "a successful message is received", %{ws_client: ws_client} do
      send_as_text(ws_client, "{\"command\":\"create\",\"room\":\"another_room\"}")

      assert_receive "{\"success\":\"another_room has been created!\"}"
    end
  end

  describe "As a User when I join a new chat room" do
    setup do
      ExChat.UserSessions.create("a-user")

      {:ok, ws_client} = connect_to "ws://localhost:4000/chat?access_token=A_USER_ACCESS_TOKEN", forward_to: self()
      send_as_text(ws_client, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      send_as_text(ws_client, "{\"command\":\"join\",\"room\":\"a_chat_room\"}")

      {:ok, ws_client: ws_client}
    end

    test "I want to receive a welcome message that contain my name and the chat room name" do
      assert_receive "{\"room\":\"a_chat_room\",\"message\":\"welcome to the a_chat_room chat room, a-user!\"}"
    end
  end

  describe "when join a new chat room" do
    setup do
      {:ok, ws_client} = connect_to "ws://localhost:4000/chat", forward_to: self()
      send_as_text(ws_client, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      send_as_text(ws_client, "{\"command\":\"join\",\"room\":\"a_chat_room\"}")

      {:ok, ws_client: ws_client}
    end

    test "an error message is received if the room does not exists", %{ws_client: ws_client} do
      send_as_text(ws_client, "{\"command\":\"join\",\"room\":\"unexisting_room\"}")

      assert_receive "{\"error\":\"unexisting_room does not exists\"}"
    end

    test "each message sent is received back", %{ws_client: ws_client} do
      send_as_text(ws_client, "{\"room\":\"a_chat_room\",\"message\":\"Hello folks!\"}")

      assert_receive "{\"room\":\"a_chat_room\",\"message\":\"Hello folks!\"}"
    end

    test "we receive all the messages sent by other clients" do
      {:ok, other_client} = connect_to "ws://localhost:4000/chat", forward_to: NullProcess.start
      send_as_text(other_client, "{\"command\":\"join\",\"room\":\"a_chat_room\"}")

      send_as_text(other_client, "{\"room\":\"a_chat_room\",\"message\":\"Hello from Twitch!\"}")

      assert_receive "{\"room\":\"a_chat_room\",\"message\":\"Hello from Twitch!\"}"
    end
  end

  describe "when send a message to an unexisting room" do
    test "an error message is received" do
      {:ok, ws_client} = connect_to "ws://localhost:4000/chat", forward_to: self()

      send_as_text(ws_client, "{\"room\":\"unexisting_room\",\"message\":\"a message\"}")

      assert_receive "{\"error\":\"unexisting_room does not exists\"}"
    end
  end

  test "avoid a client to join twice to a room" do
    {:ok, ws_client} = connect_to "ws://localhost:4000/chat", forward_to: self()

    send_as_text(ws_client, "{\"command\":\"join\"}")
    send_as_text(ws_client, "{\"command\":\"join\"}")

    assert_receive "{\"room\":\"default\",\"message\":\"welcome to the default chat room, default-user-session!\"}"
    refute_receive "{\"room\":\"default\",\"message\":\"welcome to the default chat room, default-user-session!\"}"
    assert_receive "{\"error\":\"you already joined the default room!\"}"
  end

  test "invalid messages are not handled" do
    {:ok, ws_client} = connect_to "ws://localhost:4000/chat", forward_to: self()

    send_as_text(ws_client, "this is an invalid message")

    refute_receive _
  end

  test "invalid commands are not handled" do
    {:ok, ws_client} = connect_to "ws://localhost:4000/chat", forward_to: self()

    send_as_text(ws_client, "{\"something\":\"invalid\"}")

    refute_receive _
  end
end
