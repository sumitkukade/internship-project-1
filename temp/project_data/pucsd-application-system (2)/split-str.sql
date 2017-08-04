Delimiter |

Create Function split_str (
    str text,
    delim text,
    pos int
    )
    Returns text
    Begin
    Return Replace(substring(substring_index(str,delim,pos),
           length(substring_index(str,delim,pos -1)) +1),delim,'');


END |

delimiter ;

