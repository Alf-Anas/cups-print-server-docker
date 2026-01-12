FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    cups \
    cups-client \
    cups-filters \
    printer-driver-gutenprint \
    dbus \
    avahi-daemon \
    && rm -rf /var/lib/apt/lists/*

COPY cupsd.conf /etc/cups/cupsd.conf

EXPOSE 631

CMD dbus-daemon --system --fork && \
    avahi-daemon --no-drop-root --no-chroot & \
    cupsd -f
