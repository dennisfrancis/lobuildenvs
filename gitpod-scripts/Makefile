SHELL := /bin/bash

ENVFILE = ./envvars.sh

include $(ENVFILE)

MYRANDNUMBER = $(shell od -vAn -N2 -tu2 < /dev/urandom | tr -d ' ')
BUILD_IS_RUNNING = $(pgrep make > /dev/null && echo yes || echo no)
LOCAL_BUILD_IS_RUNNING = $(pgrep vim > /dev/null && echo yes || echo no)

NPM = $(UHOME)/.nvm/versions/node/v13.6.0/bin/npm

.PHONY: noop mydebug clean-core clean-online clean stop \
	autogen.input core core.incbuild online online.incbuild \
	core.check online.check online.unitcheck online.cypress-check \
	core.git.pull online.git.pull core.log online.log status \
	core.check.log online.check.log \
	build2store buildsession build-tarballs download extract-local \
	nobuilds-running setup-buildmc upload list warn-builds-running nobuilds-running-local \
	init init-core init-online update-packages \
	extract-local-core extract-local-online setupnpm

noop:
	@echo "No-op target"

mydebug: warn-builds-running
	@echo "MYRANDNUMBER = $(MYRANDNUMBER)"
	@echo "workspace = $(WORKSPACE)"
	@echo "LODEVSETUP_DIR = $(LODEVSETUP_DIR)"
	@echo "ONLINE_CONFIG_CMD = $(ONLINE_CONFIG_CMD)"
	@echo "LOCAL_BUILD_IS_RUNNING = $(LOCAL_BUILD_IS_RUNNING)"
	cd $(WORKSPACE)
	@{ echo "inside namespace" && echo "still in namespace..."; } && \
		{ echo "second namespace"; echo "still in second"; } && \
		echo "final" && echo host: dennis@buildmc
	-false
	@echo "COREDIR = $(COREDIR)"
	@echo "finished sucessfully"


init: init-core init-online

stop:
	pkill make; pkill clang

init-core: stop
	cd $(WORKSPACE)
	git clone --depth 1000 --single-branch --branch $(CORE_BRANCH) $(COREURL) $(REPODIR)

init-online: stop
	cd $(WORKSPACE)
	git clone --depth 1000 --single-branch --branch $(ONLINE_BRANCH) $(ONLINEURL) $(ONLINEREPODIR)

autogen.input: autogen.input
	cat autogen.input | sed -e 's/--with-parallelism=.*/--with-parallelism=$(NPARALLEL)/' > $(COREDIR)/autogen.input

copyscripts:
	@echo "[copyscripts] Copying $(ENVFILE) and buildall.sh to workspace($(WORKSPACE))"
	cp $(ENVFILE) $(WORKSPACE)/
	cp buildall.sh $(WORKSPACE)/

start-buildall: autogen.input copyscripts
	@echo "[start-buildall] Starting builds in the background."
	cd $(WORKSPACE)
	./buildall.sh > /dev/null 2>&1 &

core.log:
	tail -f $(CORE_BUILD_LOG)

core.check.log:
	tail -f $(CORE_CHECK_LOG)

online.log:
	tail -f $(ONLINE_BUILD_LOG)

online.check.log:
	tail -f $(ONLINE_CHECK_LOG)

status:
	TZ=Asia/Kolkata uptime
	bash ./printBuildInfo.sh
	tail $(BUILDALL_LOG)

