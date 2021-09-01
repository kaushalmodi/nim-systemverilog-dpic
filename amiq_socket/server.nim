import std/[asyncdispatch, asyncnet, strformat, strutils, sequtils, random]

const
  serverPort = 54000.Port
  delim = ","

type
  Client = ref object
    socket: AsyncSocket
    netAddr: string
    connected: bool

  Server = ref object
    socket: AsyncSocket

proc `$`(c: Client): string =
  &"Client {c.netAddr}"

proc computeResponse(msg: string): string =
  var
    values: seq[string]
  let
    action = msg.split(':')[0]
    num = msg.split(':')[1].parseInt()
  case (action)
  of "sel", "in":
    for i in 0 .. num:
      values.add($rand(1))     # random value between 0 and 1
  of "delay":
    for i in 0 .. num:
      values.add($(rand(9)+1)) # random value between 1 and 10
  else:
    echo "[ERROR] Message not recognized!"
    return "error"
  return values.join(delim)

proc processMessages(s: Server, c: Client) {.async.} =
  while true:
    let
      line = await c.socket.recvLine()
    if line.len == 0:
      echo &"{c} disconnected!"
      c.connected = false
      c.socket.close()
      return

    echo &"{c} sent: {line}"

    if c.connected:
      await c.socket.send(&"{computeResponse(line)} \c\l")

proc loop(s: Server; port = serverPort) {.async.} =
  s.socket.bindAddr(port)
  s.socket.listen()
  echo &"Listening on port {port.int} .."

  while true:
    let
      (netAddr, clientSocket) = await s.socket.acceptAddr()
    echo &"Accepted connection from {netAddr}"

    let
      c = Client(socket: clientSocket,
                 netAddr: netAddr,
                 connected: true)
    asyncCheck processMessages(s, c)

when isMainModule:
  randomize()

  var
    server = Server(socket: newAsyncSocket())
  waitFor loop(server)
