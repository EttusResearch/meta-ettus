FROM ghcr.io/siemens/kas/kas:4.8.2
USER root
RUN apt-get update && \
	apt-get install --no-install-recommends -y ccache zip && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT []
