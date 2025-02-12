version = "0.1"

options {
  prefix      = "errata-"
  base_url    = "https://dannykopping.github.io/errata/errata/"
  description = "Below is a set of errors that the `eish` program can return."
}

/*
  File-related errata
*/
error "file-not-found" {
  message    = "File path is incorrect or inaccessible"
  categories = ["file"]
  guide      = "Ensure the given file exists and can be accessed by errata"
  args       = [
    arg("path", "string")
  ]
  labels     = {
    severity = "fatal"
  }
}
error "file-not-readable" {
  message    = "File is unreadable"
  categories = ["file"]
  guide      = "Ensure the given file has the correct permissions"
  args       = [
    arg("path", "string")
  ]
  labels     = {
    severity = "fatal"
  }
}

/*
  Datasource-related errata
*/
error "invalid-definitions" {
  message    = "One or more definitions declared in are invalid"
  categories = ["definitions", "validation"]
  args       = [
    arg("path", "string")
  ]
  labels     = {
    severity = "fatal"
  }
}
error "invalid-syntax" {
  message    = "File has syntax errors"
  categories = ["parsing"]
  args       = [
    arg("path", "string")
  ]
  labels     = {
    severity = "fatal"
  }
}

error "invalid-datasource" {
  message    = "Datasource file is invalid"
  categories = ["datasource"]
  guide      = "Check the given datasource file for errors"
  args       = [
    arg("path", "string")
  ]
  labels     = {
    severity = "fatal"
  }
}

error "argument-label-name-clash" {
  message    = "An error definition contains a label with the same name as an argument"
  categories = ["datasource", "validation"]
  guide      = "Error definitions must have labels with keys that are unique across the list of arguments"
  args       = [
    arg("key", "string")
  ]
  labels     = {
    severity = "fatal"
  }
}

/*
  Code-generation errata
*/
error "code-gen" {
  message    = "Code generation failed"
  categories = ["codegen"]
  guide      = "The provided template may contain errors"
  labels     = {
    severity = "fatal"
  }
}
error "template-execution" {
  message    = "Error in template execution"
  cause      = "Possible use of missing or renamed field, or misspelled function"
  categories = ["codegen"]
  labels     = {
    severity = "fatal"
  }
}

/*
  Web-UI errata
*/
error "markdown-rendering" {
  message    = "Markdown rendering failed"
  categories = ["web-ui"]
  labels     = {
    severity = "warning"
  }
}
error "serve-web-ui" {
  message    = "Cannot serve web UI for datasource %q"
  args       = [
    arg("path", "string")
  ]
  categories = ["serve", "web-ui"]
  labels     = {
    severity = "fatal"
  }
}
error "serve-unknown-route" {
  message    = "Requested route not defined"
  args       = [
    arg("route", "string")
  ]
  categories = ["serve", "web-ui"]
  labels     = {
    severity = "warning"
  }
}
error "serve-method-not-allowed" {
  message    = "Given HTTP method for requested route is not allowed"
  args       = [
    arg("route", "string"),
    arg("method", "string"),
  ]
  categories = ["serve", "web-ui"]
  labels     = {
    severity = "warning"
  }
}
error "serve-unknown-code" {
  message    = "Cannot find error definition for given code %q"
  args       = [
    arg("code", "string")
  ]
  categories = ["serve", "web-ui"]
  labels     = {
    severity = "warning"
    http_status_code = "404",
  }
}
error "serve-search-index" {
  message    = "Failed to build search index"
  categories = ["serve", "web-ui", "search"]
  labels     = {
    severity = "fatal"
  }
}
error "serve-search-missing-term" {
  message    = "Search request is missing a \"term\" query string parameter"
  categories = ["serve", "web-ui", "search"]
  labels     = {
    severity = "warning"
  }
}