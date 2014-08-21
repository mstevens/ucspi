include config.mk

.PHONY: all clean install dist
.SUFFIXES: .c .o

all: socks sslc ucspi-tee

socks: socks.o
	${CC} -g -static -o $@ socks.o

ucspi-tee: ucspi-tee.o
	${CC} -g -static -o $@ ucspi-tee.o

# Just for some tests.  Don't use this.
tcpclient: tcpclient.o
	${CC} -static -o $@ tcpclient.o

httpc: httpc.o
	${CC} -static -o $@ httpc.o

sslc: sslc.o
	${CC} -static -o sslc sslc.o ${LDFLAGS_SSL}

.c.o:
	${CC} ${CFLAGS} -c $<

clean:
	rm -rf *.core *.o obj/* socks tcpclient sslc httpc ucspi-tools-*

install: all
	mkdir -p ${DESTDIR}${BINDIR}
	mkdir -p ${DESTDIR}${MAN1DIR}
	install -m 775 socks ${DESTDIR}${BINDIR}
	install -m 775 sslc ${DESTDIR}${BINDIR}
	install -m 444 socks.1 ${DESTDIR}${MAN1DIR}
	install -m 444 sslc.1 ${DESTDIR}${MAN1DIR}

dist: clean
	mkdir -p ucspi-tools-${VERSION}
	cp socks.c socks.1 sslc.c sslc.1 README.md config.mk Makefile \
	    ucspi-tools-${VERSION}
	tar czf ucspi-tools-${VERSION}.tar.gz ucspi-tools-${VERSION}
