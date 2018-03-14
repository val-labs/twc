all: clean test
	@make c/u/genesis.yaml
	@make mine
	@make mine
	@make mine
c/u/genesis.yaml:
	@mkdir -p c/u c/i c/b c/t c/n
	@echo '$$$$TTL: *'            >c/t/start_ttl
	@echo 0 >c/t/prvno
	@echo 0 >c/t/diff
	@echo NONCE >c/t/nonce
	@touch c/u/genesis.yaml
	@echo ---
mine:
	@mv c/u/* c/n 2>/dev/null || :
	@expr `cat c/t/prvno` + 1 >c/t/blkno
	@cat c/n/* >c/t/block.raw
	@openssl ripemd160 <c/t/block.raw >c/t/iid
	@echo '$$$$~:' `cat c/t/iid` `cat c/t/nonce` `cat c/t/diff` >c/t/prelude
	@openssl ripemd160 <c/t/prelude >c/t/id
	@cp              c/t/start_ttl c/t/prefix
	@echo '$$$$Id:' `cat c/t/id` >>c/t/prefix
	@cp c/t/blkno c/t/prvno
	@expr `cat c/t/diff` + 1 >c/t/diff2
	@echo Diff: `cat c/t/diff2` >c/n/Diff
	@cp c/t/diff2 c/t/diff
	@echo '~~:' >c/n/_
	@cat c/t/pre* c/t/block.raw
	@echo ---
test:
	@echo testing...
	@.ve2/bin/python -m pyaml <block.yaml >/dev/null
	@.ve3/bin/python -m pyaml <block.yaml >/dev/null
	@.ve2/bin/python test.py
	@.ve3/bin/python test.py
clean:
	@rm -fr c
realclean:
	@rm -fr .ve? pkcrypt
install: realclean
	virtualenv -p python2 .ve2
	virtualenv -p python3 .ve3
	.ve2/bin/pip install -r requirements.txt
	.ve3/bin/pip install -r requirements.txt
	git clone https://github.com/val-labs/pkcrypt.git
	cd pkcrypt ; ../.ve2/bin/python setup.py install
	cd pkcrypt ; ../.ve3/bin/python setup.py install
