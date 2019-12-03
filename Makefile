all: report.tsv

PL2S = pl2sparql -i obo_prefixes  -u obo_metadata/oio  -A ~/repos/onto-mirror/void.ttl -m obo=http://purl.obolibrary.org/obo/

disjoint_sets.pro: disjoint_sets.txt
	./disjoint_sets2pro.pl $< > $@.tmp && mv $@.tmp $@

report.tsv: disjoint_sets.pro
	$(PL2S)  --debug index -e -f tsv -l --consult disjoint_sets.pro --consult disjoint_sets_query.pro -i go -i go_edit report violation  > $@.tmp && mv $@.tmp $@

#t-%:
#	 GO:0072181
