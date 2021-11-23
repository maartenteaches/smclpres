clear all
cd "c:\mijn documenten\projecten\stata\smclpres"
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
    void                          parsedirs()
    void                          cd()

    void                          parse_args()
    string                 matrix extract_args()
    void                          notallowed()
    void                          no_arg_err()
    void                          allowed_arg_err()
    void                          p_toc_sec_sub_sub()
    void                          p_toc_font()
    void                          p_toc_subtitlepos()
    void                          p_toc_hline()
    void                          p_toc_itemize()
    void                          p_toc_name()
    void                          p_toc_nodigr()
    void                          p_tocfiles_name()
    void                          changemarkname()
    void                          p_tocfiles_p2()
    void                          p_tocfiles_on_off()
    void                          p_tocfiles_customname()
    void                          p_tocfiles_howdisplay()
    void                          p_tocfiles_howdisplay_default()
    void                          p_digr()
    void                          p_ex()
    void                          p_topbar_on_off()
    void                          p_topbar_hline()
    void                          p_topbar_nosubsec()
    void                          p_topbar_font()
    void                          p_topbar_sep()
    void                          p_bottombar_hline()
    void                          p_bottombar_arrow_label()
}
end
do _smclpres_definitions.mata
do _smclpres_init.mata
do _smclpres_read.mata
