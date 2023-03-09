all:
	./add.sh
	./add-pristine.sh
	./apply-reverse.sh
	./apply-depsonly.sh
	./apply-tonew.sh
	./apply-every.sh
	./apply-randomly.sh
	./archive.sh
	./binary.sh
	./clone.sh
	./clone-while.sh
	./clone-matryoshka.sh
	./credit.sh
	./fork-apply.sh
	./fork-carousel.sh
	./fork-kernels.sh
	./fork-train.sh
	./emptiness.sh
	./fork-unrec.sh
	./file2dir.sh
	./doubleitems.sh
	./mv-remove.sh
	./push.sh
	./pull1.sh
	./pull-loop.sh
	./readd.sh
	./record.sh
	# ./record-patience.sh
	./rec-editor.sh
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
	# ./a-patience.sh

	echo "OK--pijul-tests"
