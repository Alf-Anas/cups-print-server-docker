FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

# Install only what E470 needs
RUN apt-get update && apt-get install -y \
    cups \
    cups-client \
    cups-filters \
    printer-driver-gutenprint \
    dbus \
    && rm -rf /var/lib/apt/lists/*

# Allow remote access to CUPS Web UI
RUN sed -i 's/Listen localhost:631/Port 631/' /etc/cups/cupsd.conf \
    && sed -i 's/<Location \/>/<Location \/>\
    \n  Allow All/' /etc/cups/cupsd.conf \
    && sed -i 's/<Location \/admin>/<Location \/admin>\
    \n  Allow All/' /etc/cups/cupsd.conf

EXPOSE 631

# Start services
CMD service dbus start && \
    service cups start && \
    tail -f /var/log/cups/error_log
