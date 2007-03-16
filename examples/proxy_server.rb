# $Id$
# Ruby-HL7 Proxy Server Example
require 'ruby-hl7'
require 'thread'
require 'socket'

srv = TCPServer.new(2402)

while true
  sok = srv.accept
  Thread.new( sok ) do |my_socket|
  end
end

