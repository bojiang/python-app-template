BUILD_ARG :=
RUN_ARG :=
RUN_CMD :=

dev:
	docker build --target dev  $(BUILD_ARG) -t "$$(basename $$PWD)-dev" .
	docker run -it --rm --net host -v $(PWD):/root/project $(RUN_ARG) "$$(basename $$PWD)-dev" tmux

prod:
	docker build --target prod $(BUILD_ARG) -t "$$(basename $$PWD)" .
	docker run -it --rm --net host -v $(PWD):/root/project $(RUN_ARG) "$$(basename $$PWD)" $(RUN_CMD)
