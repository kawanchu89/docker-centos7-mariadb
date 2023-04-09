FROM centos:7

# 日本語対応, タイムゾーン設定
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
ENV LANG="ja_JP UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8" \
    TZ="Asia/Tokyo"

# MariaDBをインストール
RUN yum -y install mariadb-server && \
    yum clean all

RUN /usr/libexec/mariadb-prepare-db-dir

# テストデータを読み込む
COPY ./init.sh /tmp
COPY ./init.sql /tmp
COPY ./aaa.sql /tmp
RUN chmod +x /tmp/init.sh && \
    /tmp/init.sh && \
    rm /tmp/init.sql && \
    rm /tmp/aaa.sql && \
    rm /tmp/init.sh

EXPOSE 3306/tcp

CMD ["/usr/bin/mysqld_safe", "--basedir=/usr"]
