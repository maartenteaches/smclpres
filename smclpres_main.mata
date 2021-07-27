clear all
cd "d:\mijn documenten\projecten\stata\smclpres"
mata:
mata set matastrict on
class smclpres {
    class AssociativeArray scalar option_parse
    string                 matrix source
    struct strsettings     scalar settings
    struct strpresentation scalar presentation
    struct strbib          scalar bib
    void                          new()
    void                          defaults()

// smclpres_read.mata
    real                   scalar count_lines()
    void                          read_file()
    real                   scalar _read_file()

    void                          parse_args()
    string                 matrix extract_args()
    void                          notallowed()
    void                          p_toc_sec_sub_sub()
}

void smclpres:: new() {
    defaults()
    source = J(0,3,"")
    option_parse.reinit("string", 2)
    option_parse.notfound(&notallowed())
    option_parse.put(("toc","link"),&p_toc_sec_sub_sub)
    option_parse.put(("toc","title"),&p_toc_sec_sub_sub)
}

do _smclpres_definitions.mata
do _smclpres_defaults.mata
do _smclpres_read.mata
end