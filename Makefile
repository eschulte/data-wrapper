MD=markdown
DC=./data-wrapper
DATA=mlb
VIEWER=$(DATA:=-viewer)

.PHONY: check clean

%-viewer: %
	$(DC) $<

test.output: mlb.txt run.sh data-wrapper
	@./run.sh |tee test.output;
	@if [ $$? -eq 0 ];then echo "PASSED";else echo "FAILED";fi

index.html: README.md test.output
	$(MD) README.md > $@;
	$(MD) test.output >> $@;

check: test.output

clean:
	rm -f $(VIEWER) weight-height-by-pos.svg test.output index.html
