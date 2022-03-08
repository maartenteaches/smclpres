clear all
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
    void                             p_font_old()
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
    void                             chk_anyopen()
    void                             chk_slideclose()
    void                             chk_slideopen()
    void                             count_slides()
    void                             where_err()
    void                             find_structure()
    void                             write_toc()
    void                             write_toc_top()
    void                             write_toc_subtitle()
    void                             write_toc_slides()
    void                             write_toc_section()
    void                             write_toc_subsection()
    void                             write_toc_title()
    void                             write_toc_files()
    string                 scalar    buildfilerow() 
    void                             write_pres_settings()              

    //_smclpres_parts.mata
    void                             write_title()
    void                             write_topbar()
    void                             write_bottombar()

    //_smclpres_slides.mata      
    real                   scalar    start_slide()
    struct strstate        scalar    start_ex()
    struct strstate        scalar    end_ex()
    struct strstate        scalar    digr_replace()
    struct strstate        scalar    write_db()
    struct strstate        scalar    write_dofiles()
    struct strstate        scalar    end_titlepage()
    struct strstate        scalar    begin_slide()
    struct strstate        scalar    end_slide()
    void                             noslideopen()
    void                             slideopen()
    void                             notxtopen()
    void                             txtopen()
    void                             exopen()
    struct strstate        scalar    begin_txt()
    struct strstate        scalar    end_txt()
    void                             write_oneline_text()
    void                             write_ex()
    void                             write_file()
    void                             write_dir()
    void                             slides_done()
    struct strstate        scalar    write_graph()
    struct strstate        scalar    write_ho_ignore()
    void                             write_slides()
    string                 scalar    remove_tab()

    //_smclpres_bib.mata
    real                   scalar    nbrace()
    string                 scalar    stripbraces()
    string                 scalar    stripbrackets()
    string                 scalar    remove_all_braces()
    void                             read_bib()
    string                 colvector collect_entries()
    void                             parse_entry()
    void                             parse_authors()
    string                 matrix    parse_author()
    string                 colvector split_on_and()
    string                 rowvector parse_name()
    void                             write_bib()
    void                             write_bib_entry()
    struct strstate        scalar    ref_replace()
    string                 scalar    write_ref()
    string                 scalar    write_single_ref()
    void                             collect_bib()
    void                             set_style()
    void                             base_style()
    void                             import_style()
    void                             parse_style_entry()
    void                             collect_refs()
    void                             key_not_found()
    string                 colvector extract_refs()
    string                 colvector extract_rawrefs()
    void                             fix_collisions()
    void                             init_bib()
}

void smclpres::run()
{
    parsedirs()
    read_file()
    find_structure()
    write_toc()
    init_bib()
    write_slides()
}

end

do _smclpres_definitions.mata
do _smclpres_init.mata
do _smclpres_read.mata
do _smclpres_toc.mata
do _smclpres_parts.mata
do _smclpres_slides.mata
do _smclpres_bib.mata
