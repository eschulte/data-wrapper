MD=markdown
DC=./data-wrapper
DATA=mlb
VIEWER=$(DATA:=-viewer)

.PHONY: check clean real-clean

%-viewer: %
	$(DC) $<

test.output: mlb.txt run.sh data-wrapper
	@./run.sh |tee test.output;
	@if [ $$? -eq 0 ];then echo "PASSED";else echo "FAILED";fi

index.html: README.md test.output prefix.html
	cat prefix.html        > $@;
	$(MD) README.md       >> $@;
	$(MD) test.output     >> $@;
	echo "</body></html>" >> $@;

check: test.output

clean:
	rm -f $(VIEWER) test.output

real-clean: clean
	rm -f weight-height-by-pos.svg index.html
