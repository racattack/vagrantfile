
if [ -f /var/named/racattack ];then
  echo "named already configured in $HOSTNAME"
  exit 0
fi

chkconfig named on
touch /var/named/racattack
chmod 664 /var/named/racattack
chgrp named /var/named/racattack
chmod g+w /var/named
chmod g+w /var/named/racattack

cp /etc/named.conf /etc/named.conf.org


grep '192.168.78.51' /etc/named.conf && echo "already configured " || sed -i -e 's/listen-on .*/listen-on port 53 { 192.168.78.51; };/' \
-e 's/allow-query .*/allow-query     { 192.168.78.0\/24; localhost; };\n        allow-transfer  { 192.168.78.0\/24; };/' \
-e '$azone "racattack" {\n  type master;\n  file "racattack";\n};\n\nzone "in-addr.arpa" {\n  type master;\n  file "in-addr.arpa";\n};' \
/etc/named.conf


echo '$ORIGIN .
$TTL 10800      ; 3 hours
racattack               IN SOA  collabn1.racattack. hostmaster.racattack. (
                                101        ; serial
                                86400      ; refresh (1 day)
                                3600       ; retry (1 hour)
                                604800     ; expire (1 week)
                                10800      ; minimum (3 hours)
                                )
                        NS      collabn1.racattack.
                        NS      collabn2.racattack.
collabn.racattack.      NS      collabn-cluster-gns.racattack.
$ORIGIN racattack.
collabn-cluster-scan    A       192.168.78.251
                        A       192.168.78.252
                        A       192.168.78.253
collabn-cluster-gns     A       192.168.78.244
collabn1                A       192.168.78.51
collabn1-priv           A       172.16.100.51
collabn1-vip            A       192.168.78.61
collabn2                A       192.168.78.52
collabn2-priv           A       172.16.100.52
collabn2-vip            A       192.168.78.62
collabn3                A       192.168.78.53
collabn3-priv           A       172.16.100.53
collabn3-vip            A       192.168.78.63
collabn4                A       192.168.78.54
collabn4-priv           A       172.16.100.54
collabn4-vip            A       192.168.78.64
collabl1                A       192.168.78.71
collabl1-priv           A       172.16.100.71
collabl1-vip            A       192.168.78.81
collabl2                A       192.168.78.72
collabl2-priv           A       172.16.100.72
collabl2-vip            A       192.168.78.82
collabl3                A       192.168.78.73
collabl3-priv           A       172.16.100.73
collabl3-vip            A       192.168.78.83
collabl4                A       192.168.78.74
collabl4-priv           A       172.16.100.74
collabl4-vip            A       192.168.78.84
collaba1                A       192.168.78.91
collaba2                A       192.168.78.92
collaba3                A       192.168.78.93
collaba4                A       192.168.78.94
localhost               A       127.0.0.1
' \
> /var/named/racattack


echo '$ORIGIN .
$TTL 10800      ; 3 hours
in-addr.arpa            IN SOA  collabn1.racattack. hostmaster.racattack. (
                                101        ; serial
                                86400      ; refresh (1 day)
                                3600       ; retry (1 hour)
                                604800     ; expire (1 week)
                                10800      ; minimum (3 hours)
                                )
                        NS      collabn1.racattack.
                        NS      collabn2.racattack.
$ORIGIN 100.16.172.in-addr.arpa.
51                      PTR     collabn1-priv.racattack.
52                      PTR     collabn2-priv.racattack.
53                      PTR     collabn3-priv.racattack.
54                      PTR     collabn4-priv.racattack.
$ORIGIN 78.168.192.in-addr.arpa.
251                     PTR     collabn-cluster-scan.racattack.
252                     PTR     collabn-cluster-scan.racattack.
253                     PTR     collabn-cluster-scan.racattack.
51                      PTR     collabn1.racattack.
52                      PTR     collabn2.racattack.
53                      PTR     collabn3.racattack.
54                      PTR     collabn4.racattack.
61                      PTR     collabn1-vip.racattack.
62                      PTR     collabn2-vip.racattack.
63                      PTR     collabn3-vip.racattack.
64                      PTR     collabn4-vip.racattack.
71                      PTR     collabl1.racattack.
81                      PTR     collabl1-vip.racattack.
72                      PTR     collabl2.racattack.
82                      PTR     collabl2-vip.racattack.
73                      PTR     collabl3.racattack.
83                      PTR     collabl3-vip.racattack.
74                      PTR     collabl4.racattack.
84                      PTR     collabl4-vip.racattack.
91                      PTR     collaba1.racattack.
92                      PTR     collaba2.racattack.
93                      PTR     collaba3.racattack.
94                      PTR     collaba4.racattack.
' \
> /var/named/in-addr.arpa



if [ ! -f /etc/rndc.key ] ; then
  rndc-confgen -a -r /dev/urandom
  chgrp named /etc/rndc.key
  chmod g+r /etc/rndc.key
  service named restart || true
fi

