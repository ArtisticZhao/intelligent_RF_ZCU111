from socketserver import BaseRequestHandler, ThreadingUDPServer
import threading
from bitstring import BitArray
from kiss import KISS_Decoder
k = KISS_Decoder()
b = BitArray()

recv_counter = 0
total_size = 110685


class Handler(BaseRequestHandler):

    def handle(self):
        global recv_counter
        global total_size
        # print('Got connection from', self.client_address)
        # Get message and client socket
        msg, sock = self.request
        r = k.AppendStream(msg)
        # write control function down here!
        #
        if r is not None:
            b.append(r)
            recv_counter += len(r)
            if recv_counter % 15 == 0:
                print("recv: " + str(recv_counter/1024) + " kB")
                f = open("t.bmp", 'wb')
                f.write(b.bytes)
                f.write(BitArray(8*(total_size-recv_counter)).bytes)
                f.close()


class upper_socket_server(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self.server = ThreadingUDPServer(('', 9999), Handler)

    def run(self):
        self.server.serve_forever()

    def go(self):
        self.setDaemon(True)
        self.start()


if __name__ == '__main__':
    f = open("t.bmp", 'wb')
    f.write(BitArray(hex='424D36B001000000000036000000280000000001000090000000010018000000000000B00100C30E0000C30E00000000000000000000').bytes)
    f.write(BitArray(8*(total_size-54)).bytes)
    f.close()
    up_ser = upper_socket_server()
    up_ser.go()
    c = input()
    # if c == 'c':
    #     print("write: ", len(b.bytes))
    #     with open('1.b', 'wb') as f:
    #         f.write(b.bytes)
    if c == 'q':
        f.close()
