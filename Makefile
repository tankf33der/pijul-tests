all:
	./add.sh
	./add-pristine.sh
	./add-viafiles.sh
	./apply-reverse.sh
	./apply-depsonly.sh
	./apply-tac.sh
	./apply-tonew.sh
	./apply-every.sh
	./apply-randomly.sh
	./apply-cross.sh
	./archive.sh
	./braid.sh
	./clone.sh
	./clone-while.sh
	./clone-matryoshka.sh
	./credit.sh
	./dependents.sh
	./doubleitems.sh
	./emptiness.sh
	./fork-apply.sh
	./fork-carousel.sh
	./fork-train.sh
	./fork-unrec.sh
	./file2dir.sh
	./mv-remove.sh
	./partial-clone-all.sh
	./partial-clone-all2.sh
	./partial-clone-sep.sh
	./push.sh
	./push-record.sh
	./pull1.sh
	# ./pull-conflict.sh
	./pull-loop.sh
	./pull-record1.sh
	./pull-recordall.sh
	./readd.sh
	./record-myers.sh
	./record-binary.sh
	./record-patience.sh
	# ./rec-editor.sh		# USELESS
	./rec-un-rec.sh
	./rec-unrec-main.sh
	./tag.sh
	./tag-mktemp.sh
	./tag-reset.sh
	./unrec-dir.sh
	./switch-files.sh
	./zigzag.sh
	# Add-ons
	./peace.sh
	./a-myers.sh
	./a-patience.sh

	echo "OK--pijul-tests"
