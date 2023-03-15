all:
	./add.sh
	./add-pristine.sh
	# ./add-viafiles.sh
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
	./doubleitems.sh
	./emptiness.sh
	./fork-apply.sh
	./fork-carousel.sh
	./fork-train.sh
	./fork-unrec.sh
	./file2dir.sh
	./mv-remove.sh
	./push.sh
	./pull1.sh
	./pull-loop.sh
	./readd.sh
	./record.sh
	./record-binary.sh
	./record-patience.sh
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
	./a-patience.sh

	echo "OK--pijul-tests"
