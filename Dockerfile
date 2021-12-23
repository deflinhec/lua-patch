FROM deflinhec/luarocks:lua5.1

ENV TZ=Asia/Taipei
RUN luarocks install dkjson && \
    luarocks install busted

WORKDIR /workspace