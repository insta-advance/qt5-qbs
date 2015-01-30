import qbs

StaticLibrary {
    name: "pcre"

    Depends { name: "cpp" }

    cpp.defines: [
        "PCRE_HAVE_CONFIG_H",
        "PCRE_STATIC",
    ]

    Group {
        name: "sources"
        prefix: project.sourceDirectory + "/qtbase/src/3rdparty/pcre/"
        files: [
            "pcre16_byte_order.c",
            "pcre16_chartables.c",
            "pcre16_compile.c",
            "pcre16_config.c",
            "pcre16_dfa_exec.c",
            "pcre16_exec.c",
            "pcre16_fullinfo.c",
            "pcre16_get.c",
            "pcre16_globals.c",
            "pcre16_jit_compile.c",
            "pcre16_maketables.c",
            "pcre16_newline.c",
            "pcre16_ord2utf16.c",
            "pcre16_refcount.c",
            "pcre16_string_utils.c",
            "pcre16_study.c",
            "pcre16_tables.c",
            "pcre16_ucd.c",
            "pcre16_utf16_utils.c",
            "pcre16_valid_utf16.c",
            "pcre16_version.c",
            "pcre16_xclass.c",
        ]
    }

    Export {
        Depends { name: "cpp" }
        cpp.includePaths: [
            project.sourceDirectory + "/qtbase/src/3rdparty/pcre",
        ]
    }
}
