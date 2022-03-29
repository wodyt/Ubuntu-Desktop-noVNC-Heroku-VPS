FROM ubuntu
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt install ssh wget npm apache2 php php-curl php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring  php-xml php-pear php-bcmath  -y

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt install dbus-x11 -y  && \
    apt install sudo -y  && \ 
    apt install bash -y  && \ 
    apt install net-tools -y  && \
    apt install novnc -y  && \ 
    apt install x11vnc -y  && \ 
    apt install xvfb -y  && \
    apt install supervisor -y  && \ 
    apt install xfce4 -y  && \
    apt install gnome-shell -y  && \
    apt install ubuntu-gnome-desktop -y  && \
    apt install gnome-session -y  && \ 
    apt install gdm3 -y  && \ 
    apt install tasksel -y  && \
    apt install ssh  -y  && \
    apt install terminator -y  && \
    apt install git -y  && \
    apt install nano -y  && \
    apt install curl -y  && \
    apt install wget -y  && \ 
    apt install zip -y  && \
    apt install unzip -y  && \
    apt install falkon -y  && \
    apt-get autoclean -y  && \
    apt-get autoremove
    
RUN wget https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.6/fahclient_7.6.21_amd64.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg -i fahclient_7.6.21_amd64.deb
RUN wget https://raw.githubusercontent.com/Trivaltx/oktetoremote/main/000-default.conf
RUN wget https://raw.githubusercontent.com/Trivaltx/Ubuntu-Desktop-noVNC-Heroku-VPS/main/config.xml
RUN rm /etc/fahclient/config.xml
RUN mv config.xml /etc/fahclient
RUN rm /etc/apache2/sites-available/000-default.conf
RUN mv 000-default.conf /etc/apache2/sites-available
RUN npm install -g wstunnel
RUN mkdir /run/sshd 
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_wstunnel
RUN a2enmod  rewrite
RUN echo 'You can play the awesome Cloud NOW! - Message from berbagi cara setting!' >/var/www/html/index.html
RUN echo 'wstunnel -s 0.0.0.0:8989 & ' >>/luo.sh
RUN echo 'service mysql restart' >>/luo.sh
RUN echo 'service apache2 restart' >>/luo.sh
RUN echo '/usr/sbin/sshd -D' >>/luo.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo root:123456|chpasswd
RUN chmod 755 /luo.sh
EXPOSE 80
CMD  /luo.sh

COPY novnc.zip /novnc.zip
COPY . /system

RUN unzip -o /novnc.zip -d /usr/share
RUN rm /novnc.zip

RUN chmod +x /system/conf.d/websockify.sh
RUN chmod +x /system/supervisor.sh

CMD ["/system/supervisor.sh"]

