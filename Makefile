X=website
type=ml
pkgs="js_of_ocaml,js_of_ocaml.ppx,compiler-libs.common,menhirLib,str,re.str,easy-format"

reason=./reason/reason.cma 

js_debug := \
--enable=debuginfo --disable=inline --enable=pretty +weak.js +toplevel.js \

re:$(X).cmo
	ocamlfind ocamlc -g -linkpkg -package $(pkgs) -o $(X) -I reason ./reason.cma $(X).cmo
	js_of_ocaml ${js_debug} $(X) -o $(X).js
	mv $(X).js built.js

$(X).cmo:$(X).re
	ocamlfind ocamlc -c -pp refmt -g -package $(pkgs) -impl $(X).re -I reason

ml:$(X).ml
	ocamlfind ocamlc -g -linkpkg -package "js_of_ocaml,js_of_ocaml.ppx" -impl $< -o $(X)
	js_of_ocaml ${js_debug} $(X) -o $(X).js

dump:$(X).ml
	ocamlfind ocamlc -g -linkpkg -package "js_of_ocaml,js_of_ocaml.ppx" -dsource -impl $< -o $(X)
	js_of_ocaml ${js_debug} $(X) -o $(X).js

clean:
	rm -f *.js *.cm* re ml dump website
