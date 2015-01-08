all: body
	cat header.html post.html footer.html > full.html

css:
	pygmentize -S default -f html > codehilite.css

body: readme.md
	python -m markdown -x codehilite -x markdown.extensions.toc -x markdown.extensions.tables readme.md > post.html