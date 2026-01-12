FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    cups \
    cups-client \
    cups-filters \
    printer-driver-gutenprint \
    && rm -rf /var/lib/apt/lists/*

# Create required runtime directories (systemd normally does this)
RUN mkdir -p /run/cups /var/spool/cups /var/log/cups && \
    chown -R root:lp /run/cups /var/spool/cups /var/log/cups && \
    chmod 755 /run/cups /var/spool/cups /var/log/cups

COPY cupsd.conf /etc/cups/cupsd.conf

EXPOSE 631

CMD ["cupsd", "-f"]

