FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    cups \
    cups-client \
    cups-filters \
    printer-driver-gutenprint \
    dbus \
    && rm -rf /var/lib/apt/lists/*

# Allow Remote Access
RUN sed -i 's/Listen localhost:631/Port 631/' /etc/cups/cupsd.conf && \
    sed -i 's/Require local/Require all granted/g' /etc/cups/cupsd.conf && \
    sed -i '/<Location \/>/,/<\/Location>/c\<Location />\n  Require all granted\n</Location>' /etc/cups/cupsd.conf && \
    sed -i '/<Location \/admin>/,/<\/Location>/c\<Location /admin>\n  Require all granted\n</Location>' /etc/cups/cupsd.conf && \
    sed -i '/<Location \/admin\/conf>/,/<\/Location>/c\<Location /admin/conf>\n  Require all granted\n</Location>' /etc/cups/cupsd.conf

EXPOSE 631

CMD service dbus start && \
    service cups start && \
    tail -f /var/log/cups/error_log
