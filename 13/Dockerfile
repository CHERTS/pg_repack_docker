FROM alpine:3.20

LABEL org.opencontainers.image.authors="sleuthhound@gmail.com"

ENV PG_MAJOR 13
ENV PG_VERSION 13.20
ENV PG_SHA256 8134b685724d15e60d93bea206fbe0f14c8295e84f1cc91d5a3928163e4fb288
ENV PG_REPACK_VERSION 1.4.6

ENV LANG en_US.utf8
WORKDIR /pg_repack

ENV DOCKER_PG_LLVM_DEPS \
		llvm15-dev \
		clang15

RUN set -eux; \
	\
	wget -O postgresql.tar.bz2 "https://ftp.postgresql.org/pub/source/v$PG_VERSION/postgresql-$PG_VERSION.tar.bz2"; \
	echo "$PG_SHA256 *postgresql.tar.bz2" | sha256sum -c -; \
	mkdir -p /usr/src/postgresql; \
	tar \
		--extract \
		--file postgresql.tar.bz2 \
		--directory /usr/src/postgresql \
		--strip-components 1 \
	; \
	rm postgresql.tar.bz2; \
	\
	apk add --no-cache --virtual .build-deps \
		$DOCKER_PG_LLVM_DEPS \
		bison \
		coreutils \
		dpkg-dev dpkg \
		flex \
		g++ \
		gcc \
		krb5-dev \
		libc-dev \
		libedit-dev \
		libxml2-dev \
		libxslt-dev \
		linux-headers \
		make \
		openldap-dev \
		openssl-dev \
		perl-dev \
		perl-ipc-run \
		perl-utils \
		python3-dev \
		tcl-dev \
		util-linux-dev \
		zlib-dev \
		icu-dev \
		readline-dev \
	; \
	\
	cd /usr/src/postgresql; \
	awk '$1 == "#define" && $2 == "DEFAULT_PGSOCKET_DIR" && $3 == "\"/tmp\"" { $3 = "\"/var/run/postgresql\""; print; next } { print }' src/include/pg_config_manual.h > src/include/pg_config_manual.h.new; \
	grep '/var/run/postgresql' src/include/pg_config_manual.h.new; \
	mv src/include/pg_config_manual.h.new src/include/pg_config_manual.h; \
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	wget -O config/config.guess 'https://git.savannah.gnu.org/cgit/config.git/plain/config.guess?id=7d3d27baf8107b630586c962c057e22149653deb'; \
	wget -O config/config.sub 'https://git.savannah.gnu.org/cgit/config.git/plain/config.sub?id=7d3d27baf8107b630586c962c057e22149653deb'; \
	\
	export LLVM_CONFIG="/usr/lib/llvm15/bin/llvm-config"; \
	export CLANG=clang-15; \
	\
	./configure \
		--enable-option-checking=fatal \
		--build="$gnuArch" \
		--enable-integer-datetimes \
		--enable-thread-safety \
		--enable-tap-tests \
		--disable-rpath \
		--with-uuid=e2fs \
		--with-gnu-ld \
		--with-pgport=5432 \
		--with-system-tzdata=/usr/share/zoneinfo \
		--prefix=/usr/local \
		--with-includes=/usr/local/include \
		--with-libraries=/usr/local/lib \
		--with-gssapi \
		--with-ldap \
		--with-tcl \
		--with-perl \
		--with-python \
		--with-openssl \
		--with-libxml \
		--with-libxslt \
		--with-icu \
		--with-llvm \
	; \
	make -j "$(nproc)" world-bin; \
	make install-world-bin; \
	make -C contrib install; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
			| grep -v -e perl -e python -e tcl \
	)"; \
	apk add --no-cache --virtual .postgresql-rundeps \
		$runDeps \
		bash \
		tzdata \
		zstd \
		icu-data-full \
		$([ "$(apk --print-arch)" != 'ppc64le' ] && echo 'nss_wrapper') \
	; \
	cd /usr/src; \
	wget -O pg_repack.zip http://api.pgxn.org/dist/pg_repack/${PG_REPACK_VERSION}/pg_repack-${PG_REPACK_VERSION}.zip \
	&& unzip pg_repack.zip || true && rm -f pg_repack.zip \
	&& cd pg_repack-${PG_REPACK_VERSION} \
	&& make \
	&& make install; \
	apk del --no-network .build-deps; \
	cd /; \
	rm -rf \
		/usr/src/pg_repack-${PG_REPACK_VERSION} \
		/usr/src/postgresql \
		/usr/local/share/doc \
		/usr/local/share/man \
	; \
	\
	pg_repack --version

COPY docker_entrypoint.sh /bin

RUN set -x \
    chmod +x /bin/docker_entrypoint.sh

ENTRYPOINT ["/bin/docker_entrypoint.sh"]
CMD ["-no-superuser-check"]
