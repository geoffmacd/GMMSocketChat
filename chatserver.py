from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor

class IphoneChat(Protocol):
	def connectionMade(self):
                self.factory.clients.append(self)
                print "clients are ", self.factory.clients
	def message(self,message):
		self.transport.write(message + '\n')
	def connectionLost(self, reason):
		self.factory.clients.remove(self)
	def dataReceived(self, data):
        	a = data.split(':')
        	if len(a) > 1:
                        command = a[0]
                        content = a[1].strip()
                        msg = ""
                        if command == "iam":
                                self.name = content
                                msg = self.name + " has joined"
                        elif command == "msg":
                                msg = self.name + ": " + content
                                print msg
                        for c in self.factory.clients:
                                c.message(msg)     

factory = Factory()
factory.clients = []
factory.protocol = IphoneChat
reactor.listenTCP(70, factory)
print "Iphone Chat server started"
reactor.run()
