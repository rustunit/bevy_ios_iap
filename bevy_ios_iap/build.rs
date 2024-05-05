// build.rs

use std::path::PathBuf;

fn main() {
    let is_doc_rs = std::env::var("DOCS_RS")
        .map(|doc| &doc == "1")
        .unwrap_or_default();

    if !is_doc_rs {
        let out_dir = PathBuf::from("./generated");

        let bridges = vec!["src/lib.rs", "src/native.rs"];
        for path in &bridges {
            println!("cargo:rerun-if-changed={}", path);
        }

        swift_bridge_build::parse_bridges(bridges)
            .write_all_concatenated(out_dir, env!("CARGO_PKG_NAME"));
    }
}
