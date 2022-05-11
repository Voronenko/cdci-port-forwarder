FROM alpine:3.6

ARG DEF_REMOTE_PORT=8081
ARG DEF_LOCAL_PORT=8081

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="cdci-port-forward" \
      org.label-schema.url="https://hub.docker.com/r/voronenko/cdci-port-forwarder/" \
      org.label-schema.vcs-url="https://github.com/voronenko/cdci-port-forward" \
      org.label-schema.build-date=$BUILD_DATE


ENV REMOTE_PORT=$DEF_REMOTE_PORT
ENV LOCAL_PORT=$DEF_LOCAL_PORT

## By default container listens on $LOCAL_PORT (8081)
EXPOSE 8081

RUN echo "Installing base packages" \
	&& apk add --update --no-cache \
		socat \
	&& echo "Removing apk cache" \
	&& rm -rf /var/cache/apk/

CMD socat tcp-listen:$LOCAL_PORT,reuseaddr,fork tcp:$REMOTE_HOST:$REMOTE_PORT & pid=$! && trap "kill $pid" SIGINT && \
      echo "Socat started listening on $LOCAL_PORT: Redirecting traffic to $REMOTE_HOST:$REMOTE_PORT ($pid)" && wait $pid
