X=website
pkgs="js_of_ocaml,js_of_ocaml.ppx,compiler-libs.common,menhirLib,str,re.str,easy-format"

js_debug := \
--enable=debuginfo --disable=inline --enable=pretty +weak.js +toplevel.js \

re:$(X).cmo
	ocamlfind ocamlc -g -linkpkg -package $(pkgs) -o $(X) reason.cma $(X).cmo
	js_of_ocaml ${js_debug} $(X) -o $(X).js
	mv $(X).js built.js

$(X).cmo:$(X).re
	ocamlfind ocamlc -c -pp refmt -g -package $(pkgs) -impl $(X).re 

ml:$(X).ml
	ocamlfind ocamlc -g -linkpkg -package "js_of_ocaml,js_of_ocaml.ppx" -impl $< -o $(X)
	js_of_ocaml ${js_debug} $(X) -o $(X).js

dump:$(X).ml
	ocamlfind ocamlc -g -linkpkg -package "js_of_ocaml,js_of_ocaml.ppx" -dsource -impl $< -o $(X)
	js_of_ocaml ${js_debug} $(X) -o $(X).js

clean:
	rm -f *.js *.cmo re ml dump website
