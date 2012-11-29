MD=markdown
DC=./data-wrapper
DATA=mlb
VIEWER=$(DATA:=-viewer)

.PHONY: check clean

%-viewer: %
	$(DC) $<

check: clean
	@./run.sh >test.output;
	@if [ $$? -eq 0 ];then echo "PASSED";else echo "FAILED";fi

index.html: README.md
	$(MD) $< > $@;

clean:
	rm -f $(VIEWER) test.output index.html
