FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    cups \
    cups-client \
    cups-filters \
    printer-driver-gutenprint \
    dbus \
    && rm -rf /var/lib/apt/lists/*

# Configure CUPS for remote access (CUPS 2.4 safe)
RUN sed -i 's/^Listen localhost:631/Port 631/' /etc/cups/cupsd.conf && \
    sed -i 's/^WebInterface No/WebInterface Yes/' /etc/cups/cupsd.conf

EXPOSE 631

CMD service dbus start && \
    service cups start && \
    tail -f /var/log/cups/error_log
