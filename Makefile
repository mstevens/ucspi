include config.mk

DEFINES += -D_XOPEN_SOURCE=700
DEFINES += -D_BSD_SOURCE
LIBS_TLS = -ltls `pkg-config --libs libssl`

.PHONY: all clean install dist
.SUFFIXES: .c .o

all: socks ucspi-tee tlsc httpc

socks: socks.o
	$(CC) -static -o $@ socks.o $(LIBS_BSD)

ucspi-tee: ucspi-tee.o
	$(CC) -static -o $@ ucspi-tee.o

# Just for some tests.  Don't use this.
tcpclient: tcpclient.o
	$(CC) -static -o $@ tcpclient.o

httpc: httpc.o
	$(CC) -static -o $@ httpc.o

tlsc: tlsc.o
	$(CC) -o tlsc tlsc.o $(LIBS_TLS) $(LIBS_BSD)

.c.o:
	$(CC) $(CFLAGS) $(DEFINES) -c $<

clean:
	rm -rf *.core *.o obj/* socks tcpclient tlsc ucspi-tee httpc ucspi-tools-*

install: all
	mkdir -p ${DESTDIR}${BINDIR}
	mkdir -p ${DESTDIR}${MAN1DIR}
	install -m 775 socks ${DESTDIR}${BINDIR}
	install -m 775 tlsc ${DESTDIR}${BINDIR}
	install -m 444 socks.1 ${DESTDIR}${MAN1DIR}
	install -m 444 tlsc.1 ${DESTDIR}${MAN1DIR}

dist: clean
	mkdir -p ucspi-tools-${VERSION}
	cp socks.c socks.1 tlsc.c tlsc.1 README.md config.mk Makefile \
	    ucspi-tools-${VERSION}
	tar czf ucspi-tools-${VERSION}.tar.gz ucspi-tools-${VERSION}
