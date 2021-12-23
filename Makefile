.PNOHY: deps
deps:
	luarocks install busted && \
		luarocks install dkjson

.PHONY: test
test: deps
	busted -o TAP

.PHONY: example
example: deps
	lua example.lua

.PHONY: docker-image
docker-image:
	docker build -t lua-patch $(shell pwd)

.PHONY: docker-test
docker-test: docker-image
	docker run -it --rm -v $(shell pwd):/workspace lua-patch busted -o TAP

.PHONY: docker-example
docker-example: docker-image
	docker run -it --rm -v $(shell pwd):/workspace lua-patch lua example.lua