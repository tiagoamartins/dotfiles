" Format Options:
" a Automatic formatting of paragraphs.  Every time text is inserted or
"   deleted the paragraph will be reformatted.
" w Trailing white space indicates a paragraph continues in the next line.
"   A line that ends in a non-white character ends a paragraph.
setlocal formatoptions+=aw

if has('spell')
    setlocal spell
endif
