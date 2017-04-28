(TeX-add-style-hook
 "Final_report"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("geometry" "a4paper" "tmargin=1in" "bmargin=1in") ("inputenc" "utf8")))
   (add-to-list 'LaTeX-verbatim-environments-local "lstlisting")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "geometry"
    "inputenc"
    "graphicx"
    "parskip"
    "pdflscape"
    "listings"
    "enumitem"
    "mathtools"
    "hyperref"
    "float"
    "caption"
    "subcaption")
   (TeX-add-symbols
    "ra")
   (LaTeX-add-labels
    "fig:1"
    "fig:2"
    "Fig :1b"
    "fig:PLL"
    "fig:tx_circuit"
    "fig:rx_circuit"
    "fig:Differentitor_circuit"
    "fig:diff_pll"
    "fig:rx_box"))
 :latex)

