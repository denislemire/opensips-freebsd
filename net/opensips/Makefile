PORTNAME=		opensips
DISTVERSION=		4.0.0
CATEGORIES=		net
# Official opensips.org 4.0.0 tree only has ChangeLog so far; use the GitHub tag.

MAINTAINER=		denis@lemire.name
COMMENT=		Open SIP Server
WWW=			https://www.opensips.org/

LICENSE=		GPLv2
LICENSE_FILE=		${WRKSRC}/COPYING

USE_GITHUB=		yes
GH_ACCOUNT=		OpenSIPS
GH_PROJECT=		opensips
GH_TAGNAME=		${DISTVERSION}

BUILD_DEPENDS=		ginstall:sysutils/coreutils \
			gtar:archivers/gtar \
			flex:textproc/flex
RUN_DEPENDS=		bash:shells/bash

USES=			bison gmake ncurses pkgconfig shebangfix ssl
USE_RC_SUBR=		opensips

SHEBANG_GLOB=		*.sh *.pl *.py *.php

USERS=			opensips
GROUPS=			opensips

# FreeBSD needs an explicit pthread link for OpenSIPS's locking/thread helpers.
LDFLAGS+=		-pthread

# Keep man pages uncompressed in the package (matches FreeBSD CI images that
# set NO_MANCOMPRESS / skip compress-man content changes).
NO_COMPRESS_MAN=	yes

WRKSRC=			${WRKDIR}/${GH_PROJECT}-${DISTVERSION}

OPTIONS_DEFINE=		CARRIERROUTE CGRATES COMPRESSION CASSANDRA COUCHBASE \
			CURL DEBUG DIALPLAN DOCS EXAMPLES GEOIP HTTP HTTP2 \
			IDENTITY JABBER JSON KAFKA LDAP LUA MEMCACHED MONGODB \
			MYSQL PERL PGSQL PRESENCE PYTHON RABBITMQ RADIUS \
			REDIS REGEX REST SCTP SIPREC SNMP SQLITE STIR TLS \
			UNIXODBC UUID XML
OPTIONS_DEFAULT=	DOCS HTTP MYSQL PGSQL TLS
OPTIONS_SUB=		yes

CARRIERROUTE_DESC=	Carrier-route module (libconfuse)
CASSANDRA_DESC=		Cassandra cachedb module
CGRATES_DESC=		CGRateS billing module
COMPRESSION_DESC=	SIP compression module (zlib)
COUCHBASE_DESC=		Couchbase cachedb module
CURL_DESC=		HTTP-backed modules needing libcurl
DEBUG_DESC=		Keep debug messages in binary
DIALPLAN_DESC=		Dialplan module (PCRE2)
GEOIP_DESC=		MaxMind GeoIP module
HTTP_DESC=		HTTP transport (libmicrohttpd)
HTTP2_DESC=		HTTP/2 server (nghttp2)
IDENTITY_DESC=		SIP Identity (RFC 4474)
JABBER_DESC=		Jabber/XMPP gateway modules
JSON_DESC=		JSON variable module
KAFKA_DESC=		Kafka event module
LDAP_DESC=		LDAP and H.350 modules
LUA_DESC=		Lua scripting module
MEMCACHED_DESC=		Memcached cachedb module
MONGODB_DESC=		MongoDB cachedb module
MYSQL_DESC=		MySQL / MariaDB database module
PERL_DESC=		Perl scripting / perlvdb modules
PGSQL_DESC=		PostgreSQL database module
PRESENCE_DESC=		Presence / PUA / XCAP stack
PYTHON_DESC=		Python scripting module
RABBITMQ_DESC=		RabbitMQ event modules
RADIUS_DESC=		RADIUS AAA module
REDIS_DESC=		Redis cachedb module
REGEX_DESC=		PCRE2 regex module
REST_DESC=		REST / HTTP client module
SCTP_DESC=		SCTP protocol module
SIPREC_DESC=		SIPREC recording module
SNMP_DESC=		SNMP statistics module
SQLITE_DESC=		SQLite database module
STIR_DESC=		STIR/SHAKEN module
TLS_DESC=		TLS / WSS (OpenSSL backend)
UNIXODBC_DESC=		unixODBC database module
UUID_DESC=		UUID generator module
XML_DESC=		XML / XML-RPC / CPL helpers

MYSQL_USES=		mysql
PGSQL_USES=		pgsql
SQLITE_LIB_DEPENDS=	libsqlite3.so:databases/sqlite3
UNIXODBC_LIB_DEPENDS=	libodbc.so:databases/unixODBC
LDAP_USE=		OPENLDAP=yes
HTTP_LIB_DEPENDS=	libmicrohttpd.so:www/libmicrohttpd
HTTP2_LIB_DEPENDS=	libnghttp2.so:www/nghttp2 \
			libevent.so:devel/libevent
MEMCACHED_LIB_DEPENDS=	libmemcached.so:databases/libmemcached
REDIS_LIB_DEPENDS=	libhiredis.so:databases/hiredis
RADIUS_LIB_DEPENDS=	libradiusclient-ng.so:net/radiusclient
DIALPLAN_LIB_DEPENDS=	libpcre2-8.so:devel/pcre2
REGEX_LIB_DEPENDS=	libpcre2-8.so:devel/pcre2
JSON_LIB_DEPENDS=	libjson-c.so:devel/json-c
REST_LIB_DEPENDS=	libcurl.so:ftp/curl
CURL_LIB_DEPENDS=	libcurl.so:ftp/curl
IDENTITY_USES=		ssl
COMPRESSION_LIB_DEPENDS=libz.so:archivers/zlib
XML_LIB_DEPENDS=	libxml2.so:textproc/libxml2
PRESENCE_LIB_DEPENDS=	libxml2.so:textproc/libxml2 \
			libcurl.so:ftp/curl
PERL_USES=		perl5
LUA_USES=		lua:53
PYTHON_USES=		python
CASSANDRA_LIB_DEPENDS=	libthrift.so:devel/thrift-cpp
MONGODB_LIB_DEPENDS=	libmongoc-1.0.so:devel/mongo-c-driver \
			libjson-c.so:devel/json-c
COUCHBASE_LIB_DEPENDS=	libcouchbase.so:databases/libcouchbase
RABBITMQ_LIB_DEPENDS=	librabbitmq.so:net/rabbitmq-c
KAFKA_LIB_DEPENDS=	librdkafka.so:net/librdkafka
GEOIP_LIB_DEPENDS=	libmaxminddb.so:net/libmaxminddb
SNMP_LIB_DEPENDS=	libnetsnmp.so:net-mgmt/net-snmp
STIR_LIB_DEPENDS=	libcurl.so:ftp/curl
SIPREC_LIB_DEPENDS=	libuuid.so:misc/e2fsprogs-libuuid
UUID_LIB_DEPENDS=	libuuid.so:misc/e2fsprogs-libuuid
CARRIERROUTE_LIB_DEPENDS=libconfuse.so:devel/libconfuse
CGRATES_LIB_DEPENDS=	libjson-c.so:devel/json-c
JABBER_LIB_DEPENDS=	libexpat.so:textproc/expat2

.include <bsd.port.options.mk>

# Map FreeBSD OPTIONS → OpenSIPS include_modules (removed from exclude list).
.if ${PORT_OPTIONS:MMYSQL}
EXTRA_MODULES+=		db_mysql
.endif
.if ${PORT_OPTIONS:MPGSQL}
EXTRA_MODULES+=		db_postgres
.endif
.if ${PORT_OPTIONS:MSQLITE}
EXTRA_MODULES+=		db_sqlite
.endif
.if ${PORT_OPTIONS:MUNIXODBC}
EXTRA_MODULES+=		db_unixodbc
.endif
.if ${PORT_OPTIONS:MTLS}
EXTRA_MODULES+=		proto_tls proto_wss tls_mgm tls_openssl
.endif
.if ${PORT_OPTIONS:MHTTP}
EXTRA_MODULES+=		httpd
.endif
.if ${PORT_OPTIONS:MHTTP2}
EXTRA_MODULES+=		http2d
.endif
.if ${PORT_OPTIONS:MLDAP}
EXTRA_MODULES+=		ldap h350
.endif
.if ${PORT_OPTIONS:MMEMCACHED}
EXTRA_MODULES+=		cachedb_memcached
.endif
.if ${PORT_OPTIONS:MREDIS}
EXTRA_MODULES+=		cachedb_redis
.endif
.if ${PORT_OPTIONS:MRADIUS}
EXTRA_MODULES+=		aaa_radius
.endif
.if ${PORT_OPTIONS:MDIALPLAN}
EXTRA_MODULES+=		dialplan
.endif
.if ${PORT_OPTIONS:MREGEX}
EXTRA_MODULES+=		regex
.endif
.if ${PORT_OPTIONS:MJSON}
EXTRA_MODULES+=		json
.endif
.if ${PORT_OPTIONS:MREST}
EXTRA_MODULES+=		rest_client
.endif
.if ${PORT_OPTIONS:MIDENTITY}
EXTRA_MODULES+=		identity
.endif
.if ${PORT_OPTIONS:MUUID}
EXTRA_MODULES+=		uuid
.endif
.if ${PORT_OPTIONS:MCURL}
EXTRA_MODULES+=		db_http emergency
.endif
.if ${PORT_OPTIONS:MSCTP}
EXTRA_MODULES+=		proto_sctp
.endif
.if ${PORT_OPTIONS:MCOMPRESSION}
EXTRA_MODULES+=		compression
.endif
.if ${PORT_OPTIONS:MXML}
EXTRA_MODULES+=		xml mi_xmlrpc pi_http cpl_c
.endif
.if ${PORT_OPTIONS:MPRESENCE}
EXTRA_MODULES+=		presence presence_dialoginfo presence_mwi presence_reginfo \
			presence_xml presence_dfks pua pua_bla pua_dialoginfo pua_mi \
			pua_reginfo pua_usrloc pua_xmpp rls xcap xcap_client
.endif
.if ${PORT_OPTIONS:MPERL}
EXTRA_MODULES+=		perl db_perlvdb
.endif
.if ${PORT_OPTIONS:MLUA}
EXTRA_MODULES+=		lua
.endif
.if ${PORT_OPTIONS:MPYTHON}
EXTRA_MODULES+=		python
.endif
.if ${PORT_OPTIONS:MCASSANDRA}
EXTRA_MODULES+=		cachedb_cassandra
.endif
.if ${PORT_OPTIONS:MMONGODB}
EXTRA_MODULES+=		cachedb_mongodb
.endif
.if ${PORT_OPTIONS:MCOUCHBASE}
EXTRA_MODULES+=		cachedb_couchbase
.endif
.if ${PORT_OPTIONS:MRABBITMQ}
EXTRA_MODULES+=		event_rabbitmq rabbitmq_consumer
.endif
.if ${PORT_OPTIONS:MKAFKA}
EXTRA_MODULES+=		event_kafka
.endif
.if ${PORT_OPTIONS:MGEOIP}
EXTRA_MODULES+=		mmgeoip
.endif
.if ${PORT_OPTIONS:MSNMP}
EXTRA_MODULES+=		snmpstats
.endif
.if ${PORT_OPTIONS:MSTIR}
EXTRA_MODULES+=		stir_shaken
.endif
.if ${PORT_OPTIONS:MSIPREC}
EXTRA_MODULES+=		siprec
.endif
.if ${PORT_OPTIONS:MCARRIERROUTE}
EXTRA_MODULES+=		carrierroute
.endif
.if ${PORT_OPTIONS:MCGRATES}
EXTRA_MODULES+=		cgrates
.endif
.if ${PORT_OPTIONS:MJABBER}
EXTRA_MODULES+=		jabber xmpp
.endif

OPENSIPS_MAKE_ENV=	CC="${CC}" \
			CXX="${CXX}" \
			CFLAGS="${CFLAGS}" \
			LDFLAGS="${LDFLAGS}" \
			LIBS="-pthread" \
			PREFIX="${PREFIX}"

do-configure:
	${CP} ${FILESDIR}/Makefile.conf ${WRKSRC}/Makefile.conf
	${REINPLACE_CMD} -e 's|_PREFIX_|${PREFIX}|' \
		-e 's|_STAGE_DIR_|${STAGEDIR}|' \
		${WRKSRC}/Makefile.conf
	${REINPLACE_CMD} -e 's/^include_modules?=.*/include_modules?= ${EXTRA_MODULES}/' \
		${WRKSRC}/Makefile.conf

do-configure-DEBUG-off:
	${REINPLACE_CMD} -e 's/^#DEFS+= -DNO_DEBUG/DEFS+= -DNO_DEBUG/' \
		${WRKSRC}/Makefile.conf

do-build:
	cd ${WRKSRC} && ${SETENV} ${OPENSIPS_MAKE_ENV} ${MAKE_CMD} \
		${MAKE_ARGS} ${_MAKE_JOBS} all

do-install:
	cd ${WRKSRC} && ${SETENV} ${OPENSIPS_MAKE_ENV} ${MAKE_CMD} \
		${MAKE_ARGS} install
	${MKDIR} ${STAGEDIR}${ETCDIR}
	${INSTALL_DATA} ${FILESDIR}/opensips.cfg.sample \
		${STAGEDIR}${ETCDIR}/opensips.cfg.sample

do-install-EXAMPLES-on:
	${MKDIR} ${STAGEDIR}${EXAMPLESDIR}
	cd ${WRKSRC}/examples && ${COPYTREE_SHARE} . ${STAGEDIR}${EXAMPLESDIR}

post-install:
	${STRIP_CMD} ${STAGEDIR}${PREFIX}/sbin/opensips
.if exists(${STAGEDIR}${PREFIX}/sbin/osipsconfig)
	${STRIP_CMD} ${STAGEDIR}${PREFIX}/sbin/osipsconfig
.endif
	${FIND} ${STAGEDIR}${PREFIX}/lib/opensips/modules -name '*.so' \
		-exec ${STRIP_CMD} {} +

post-install-RADIUS-on:
	${INSTALL_DATA} ${WRKSRC}/etc/dictionary.opensips \
		${STAGEDIR}${ETCDIR}/dictionary.opensips.sample

.include <bsd.port.mk>
