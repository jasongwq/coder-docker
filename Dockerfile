FROM codercom/code-server

RUN cat /etc/apt/sources.list
RUN sudo sed -i "s/deb.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list \
    && sudo sed -i "s/security.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list
RUN  sudo apt update \
    && sudo apt -y -q install golang make

USER 0:0
#ADD https://gomirrors.org/dl/go/go1.14.linux-amd64.tar.gz /usr/lib/go-1.14/
RUN mkdir /usr/lib/go-1.14/ && \
    cd /usr/lib/go-1.14/ && \
    curl https://dl.google.com/go/go1.14.linux-amd64.tar.gz -o go1.14.linux-amd64.tar.gz&& \
    tar xzf go1.14.linux-amd64.tar.gz && \
    rm -f go1.14.linux-amd64.tar.gz
     
#COPY go1.14.linux-amd64.tar.gz /usr/lib/go-1.14/
COPY golangci-lint /root/go/bin/
COPY promu /root/go/bin/
ENV PATH=$PATH:/usr/local/go-1.14/go/bin
ENV GOROOT=/usr/lib/go-1.14/go
ENV GOPROXY=https://goproxy.io
ENV GO111MODULE=on
RUN sudo rm /usr/bin/go \
    && ln -s /usr/lib/go-1.14/go/bin/go /usr/bin/go


### nodejs yarn
RUN sudo apt-get install -y gnupg2 \
    &&curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
    && sudo apt update && sudo apt install yarn \
    && yarn config set registry https://registry.npm.taobao.org
### python pip
RUN sudo apt install -y python3-pip \
    && pip3 install -U selenium  -i https://pypi.douban.com/simple
RUN pip3 install flask psycopg2-binary requests  -i https://pypi.douban.com/simple
RUN cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib/code-server/bin/../lib/libstdc++.so.6
#psycopg2
###
#COPY fun-v3.6.14-linux /usr/local/bin/fun
 
WORKDIR /root/
