VERSION_FILE = pyinsane2/_version.py
PYTHON ?= python3

build: build_c build_py

install: install_py install_c

uninstall: uninstall_py

build_py: ${VERSION_FILE}
	${PYTHON} ./setup.py build

build_c:

${VERSION_FILE}:
	echo version = \"$(shell git describe --always)\" >> $@

version: ${VERSION_FILE}

doc: install_py
	(cd doc && make html)
	cp doc/index.html doc/build/index.html

check:
	flake8
# 	pydocstyle pyinsane2

test: ${VERSION_FILE}
	tox

linux_exe:

windows_exe:

release:
ifeq (${RELEASE}, )
	@echo "You must specify a release version (make release RELEASE=1.2.3)"
else
	@echo "Will release: ${RELEASE}"
	@echo "Checking release is in ChangeLog ..."
	grep ${RELEASE} ChangeLog
	@echo "Releasing ..."
	git tag -a ${RELEASE} -m ${RELEASE}
	git push origin ${RELEASE}
	make clean
	make version
	${PYTHON} ./setup.py sdist upload
	@echo "All done"
endif

clean:
	rm -rf doc/build
	rm -rf build dist *.egg-info
	rm -f ${VERSION_FILE}

install_py: ${VERSION_FILE}
	${PYTHON} ./setup.py install ${PIP_ARGS}

install_c:

uninstall_py:
	pip3 uninstall -y pyinsane2

uninstall_c:

help:
	@echo "make build || make build_py"
	@echo "make check"
	@echo "make doc"
	@echo "make help: display this message"
	@echo "make install || make install_py"
	@echo "make release"
	@echo "make test"
	@echo "make uninstall || make uninstall_py"

.PHONY: \
	build \
	build_c \
	build_py \
	check \
	doc \
	linux_exe \
	windows_exe \
	help \
	install \
	install_c \
	install_py \
	release \
	test \
	uninstall \
	uninstall_c \
	version
