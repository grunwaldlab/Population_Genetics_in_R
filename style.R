
# Knitr hooks
knitr::knit_hooks$set(
  hide_button = function(before, options, envir) {
    if (is.character(options$hide_button)) {
      button_text = options$hide_button
    } else {
      button_text = "Show solution"
    }
    block_label <- paste0("hide_button", options$label)
    if (before) {
      return(paste0(sep = "\n",
                   '<button class="btn btn-danger" data-toggle="collapse" data-target="#', block_label, '"> ', button_text, ' </button>\n',
                   '<div id="', block_label, '" class="collapse">\n'))
    } else {
      return("</div><br />\n")
    }
  },
  output = function(x, options){
    x <- gsub(x, pattern = "<", replacement = "&lt;")
    x <- gsub(x, pattern = ">", replacement = "&gt;")
    paste0(
      "<pre class=\"r-output\"><code>",
      fansi::sgr_to_html(x = x, warn = TRUE, term.cap = "256"),
      # ansistrings::ansi_to_html(text = x, fullpage = FALSE),
      "</code></pre>"
    )
  }
)

