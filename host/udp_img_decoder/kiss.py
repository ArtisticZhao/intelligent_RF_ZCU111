# coding:utf-8
"""
KISS数据协议
"""
from copy import deepcopy


KISS_FEND = ord('\xC0')  # 192
KISS_FESC = ord('\xDB')  # 219
KISS_TFEND = ord('\xDC')  # 220
KISS_TFESC = ord('\xDD')  # 221


class KISS_Decoder():
    '''
    @ KISS协议解码器
    每次解码之后，会将包数据放入packets中， 因为网络有可能有残废包，但残废包是不能通过解包程序，可以直接无视掉
    '''

    def __init__(self):
        self.in_esc_mode = False
        self.data_buf = bytes()
        self.decoded_len = 0

    def AppendStream(self, stream_data):
        '''
        @ stream_data : kiss 编码的数据，只需要讲KISS数据帧，按照顺序通过
        stream_data传入，当解码完毕后会自动返回数据包，并重置解码器等待下一次解码
        '''
        for b in stream_data:
            if not self.in_esc_mode:
                if b == KISS_FEND:
                    if self.decoded_len != 0:
                        remsg = deepcopy(self.data_buf)  # 解码出一个包！！！
                        self.reset_kiss()
                        return remsg

                elif b == KISS_FESC:
                    self.in_esc_mode = True

                else:
                    self.data_buf += bytes([b])
                    self.decoded_len += 1

            else:
                if b == KISS_TFEND:
                    self.data_buf += b'\xc0'  # (KISS_FEND)
                elif b == KISS_TFESC:
                    self.data_buf += b'\xdb'  # (KISS_FESC)

                self.decoded_len += 1
                self.in_esc_mode = False

    def reset_kiss(self):
        '''
        @ 重置decoder
        '''
        self.data_buf = bytes()
        self.decoded_len = 0
