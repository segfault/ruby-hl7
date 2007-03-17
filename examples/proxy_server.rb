# $Id$
# Ruby-HL7 Proxy Server Example
require 'ruby-hl7'
require 'thread'
require 'socket'

srv = TCPServer.new(2402)
target_ip = "127.0.0.1"
target_port = 5900

while true
  sok = srv.accept
  Thread.new( sok ) do |my_socket|
    raw_inp = my_socket.readlines
    msg = HL7::Message.new( raw_input )
    soc = TCPSocket.open( target_ip, target_port )
    soc.write msg.to_mllp
    soc.close
  end
end

