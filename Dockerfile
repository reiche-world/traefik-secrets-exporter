FROM alpine/kubectl:1.35.0
RUN apk add --no-cache jq
COPY extract.sh /usr/bin/
RUN chmod +x /usr/bin/extract.sh
ENTRYPOINT [ "/usr/bin/extract.sh" ]
