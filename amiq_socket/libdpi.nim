import std/[strformat, asyncdispatch, asyncnet]

type
  ClientConfigRef = ref object
    port: Port
    hostName: string
    msg: string
    rcvdMsg: string

proc client(cc: ClientConfigRef) {.async.} =
  var
    socket = newAsyncSocket()

  # 1. Connect to the server
  when defined(debug):
    echo &"Connecting to {cc.hostName}"
  await socket.connect(cc.hostName, cc.port)
  when defined(debug):
    echo "Connected!"

  # 2. Send message
  await socket.send(cc.msg & "\c\l")

  # 3. Receive message
  cc.rcvdMsg = await socket.recvLine()
  echo &"Client received: {cc.rcvdMsg}"

  when defined(debug):
    echo "Closing socket .."
  socket.close()

proc call_client(hostName: cstring; port: cint; msg: cstring): cstring {.exportc, dynlib.} =
  var
    cc = ClientConfigRef(port: port.Port,
                         hostName: $hostName,
                         msg: $msg)

  waitFor client(cc)
  return cc.rcvdMsg.cstring
