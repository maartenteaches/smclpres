clear all
cd "d:\mijn documenten\projecten\stata\smclpres"
mata:
mata set matastrict on
class smclpres {

    class AssociativeArray scalar option_parse
    string                 matrix source

// _smclpres_definitions.mata    
    struct strsettings     scalar settings
    struct strpresentation scalar presentation
    struct strbib          scalar bib

// _smclpres_init.mata    
    void                          new()
    void                          defaults()

// _smclpres_read.mata
    real                   scalar count_lines()
    void                          read_file()
    real                   scalar _read_file()

    void                          parse_args()
    string                 matrix extract_args()
    void                          notallowed()
    void                          p_toc_sec_sub_sub()
    void                          p_toc_font()
}

do _smclpres_definitions.mata
do _smclpres_init.mata
do _smclpres_read.mata
end