let module Ev = Lwt_js_events;

let log str => Js.Unsafe.meth_call Firebug.console "log" [|Js.Unsafe.inject str|];
let set = Js.Unsafe.set;
let get = Js.Unsafe.get;

let bind_event ev elem handler => {
  let handler evt _ => handler evt;
  Ev.(async @@ (fun () => ev elem handler))
};

log "asdasdasd";

log "test2";


Sys_js.register_file name::"buffer.txt" content::"(* test *)";

type conversionT = Ml2re | Re2ml;

let refmt conversion str => {
  Sys_js.update_file name::"buffer.txt" content::str;
  let lexbuf = (Reason_toolchain.setup_lexbuf false "buffer.txt");
  switch conversion {
  | Ml2re => 
    let ((ast, comments), parsedAsML, parsedAsInterface) = 
      (Reason_toolchain.ML.canonical_implementation_with_comments lexbuf, true, false);
    let reason_formatter = Reason_pprint_ast.createFormatter ();
    reason_formatter#structure_string comments ast
  | Re2ml => 
    let ((ast, comments), parsedAsML, parsedAsInterface) = 
      (Reason_toolchain.JS.canonical_implementation_with_comments lexbuf, false, false);
    Pprintast.string_of_structure ast
  }
};

let reta = Dom_html.createTextarea Dom_html.document;
let mlta = Dom_html.createTextarea Dom_html.document;
let body = get Dom_html.document "body";

set (get body "style") "backgroundColor" "#333"; 

set mlta "value" "(* ml *)";
set (get mlta "style") "width" "50%";
set (get mlta "style") "height" "75%";
set reta "value" "/* re */";
set (get reta "style") "width" "50%";
set (get reta "style") "height" "75%";

Dom.appendChild body mlta;
Dom.appendChild body reta;

let do_convert ta evt dir =>
  set ta "value" (refmt dir (Js.to_string (get (get evt "target") "value")));

bind_event Ev.keyups mlta (fun evt => 
  Lwt.return (do_convert reta evt Ml2re));
bind_event Ev.keyups reta (fun evt =>
  Lwt.return (do_convert mlta evt Re2ml));
