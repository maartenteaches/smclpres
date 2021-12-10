clear all
cd "d:\mijn documenten\projecten\stata\smclpres"
mata:
mata set matastrict on
class smclpres {
    string                 matrix    source
    real                   matrix    source_version
    real                   scalar    rows_source
    real                   rowvector smclpres_version
    class AssociativeArray scalar    files
    
// smclpres_main.mata
    void                             run()

// _smclpres_definitions.mata    
    struct strsettings     scalar    settings
    struct strbib          scalar    bib
    struct strslide        rowvector slide
   	struct strslide        scalar    tocslide
	struct strslide        scalar    titleslide

// _smclpres_init.mata    
    void                             new()
    void                             defaults()

// _smclpres_read.mata
    real                   scalar    count_lines()
    void                             read_file()
    real                   scalar    _read_file()
    void                             parsedirs()
    void                             cd()
    real                   rowvector parse_version()
    real                   scalar    pres_lt_val()
    real                   scalar    pres_leq_val()
    real                   scalar    pres_gt_val()
    real                   scalar    pres_geq_val()
    real                   scalar    sp_fopen()
    void                             sp_fclose()
    void                             sp_fcloseall()

    void                             parse_args()
    string                 matrix    extract_args()
    void                             generic_err_msg()
    void                             notallowed()
    void                             no_arg_err()
    void                             allowed_arg_err()
    void                             p_layout()
    void                             p_toc_sec_sub_sub()
    void                             p_font()
    void                             p_pos()
    void                             p_hline()
    void                             p_toc_itemize()
    void                             p_toc_name()
    void                             p_toc_nodigr()
    void                             p_tocfiles_name()
    void                             changemarkname()
    void                             p_tocfiles_p2()
    void                             p_tocfiles_on_off()
    void                             p_tocfiles_customname()
    void                             p_tocfiles_howdisplay()
    void                             p_tocfiles_howdisplay_default()
    void                             p_digr()
    void                             p_ex()
    void                             p_topbar_on_off()
    void                             p_topbar_nosubsec()
    void                             p_topbar_sep()
    void                             p_bottombar_arrow_label()
    void                             p_bottombar_name()
    void                             p_tab()
    void                             p_bib_file()
    void                             p_bib_opt()
    void                             toc_indent_settings()

    // _smclpres_toc.mata
    void                             count_slides()
    void                             where_err()
    void                             find_structure()
    void                             write_toc()
    void                             write_toc_top()
    void                             write_toc_subtitle()

    //_smclpres_parts.mata
    void                             write_title()
}

void smclpres::run()
{
    parsedirs()
    read_file()
    find_structure()
}

end

do _smclpres_definitions.mata
do _smclpres_init.mata
do _smclpres_read.mata
do _smclpres_toc.mata
do _smclpres_parts.mata
