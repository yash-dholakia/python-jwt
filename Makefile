
export PYTHONPATH=.
PYVOWS = ./test/pyvows.sh

all: lint test

docs: build_docs

build_docs:
	cd docs && make html

lint:
	pylint jwt test bench

test: run_test

run_test:
	$(PYVOWS) test

coverage: run_coverage

run_coverage:
	$(PYVOWS) --cover --cover-package jwt --cover-report coverage/coverage.xml test

bench: run_bench

run_bench:
	for b in ./bench/*_bench.py; do $$b; done

bench_gfm: 
	for b in ./bench/*_bench.py; do $$b --gfm; done

node_deps:
	mkdir -p node_modules && npm install jsjws sinon

egg: build_egg

build_egg:
	rm -f egg/*.egg	
	./egg/bentomaker.py --build-directory=egg/build \
                            build_egg \
                            --output-dir=egg && \
        zip -j egg/*.egg bento.info egg/bentomaker.py egg/setup.py && \
        cd egg && zip *.egg EGG-INFO/dependency_links.txt
