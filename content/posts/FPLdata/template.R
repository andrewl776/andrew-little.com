write_template <- function(date) {

 template <- c("---", "title: \"{FPLdata} R Package\"", "thumbnailImagePosition: left",
    "thumbnailImage: //d1u9biwaxjngwg.cloudfront.net/cover-image-showcase/city-750.jpg",
    "date: {{date}}", "categories:", "- tranquilpeak", "- features",
    "tags:", "  - pagination", "showPagination: false", "---", "",
    "")

 unname(vapply(template, function(s) glue::glue(s, .open = "{{", .close = "}}"), character(1)))

}
