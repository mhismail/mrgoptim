# Copyright (C) 2013 - 2017  Metrum Research Group, LLC
#
# This file is part of mrgsim
#
# mrgsim is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# mrgsim is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with mrgsim.  If not, see <http://www.gnu.org/licenses/>.


add_name_list <- function(x,where="name") {
  mapply(x,names(x),SIMPLIFY=FALSE,FUN=function(a,b) {
    a[[where]] <- b
    a
  })
}

Eval <- function(x) {
  eval(parse(text=x))
}

cropstr <- function(string, prefix, suffix, bump= "...") {
  nc <- nchar(string)
  total <- prefix+suffix
  if(all(nc <= total)) return(string)
  paste0(substr(string,1,prefix) , bump, substr(string,(nc-suffix+nchar(bump)+1),nc))
}

mytrim <- function(x) {
  gsub("^\\s+|\\s+$", "",x,perl=TRUE)
}

mytriml <- function(x) {
  gsub("^\\s+", "",x,perl=TRUE)
}

mytrimr <- function(x) {
  gsub("\\s$", "",x,perl=TRUE)
}


## Create character vector
## Split on comma or space
cvec_cs <- function(x) {
  if(is.null(x) | length(x)==0) return(character(0))
  x <- unlist(strsplit(as.character(x),",",fixed=TRUE),use.names=FALSE)
  x <- unlist(strsplit(x," ",fixed=TRUE),use.names=FALSE)
  x <- x[x!=""]
  if(length(x)==0) {
    return(character(0))
  } else {
    return(x)
  }
}

## Create a character vector
## Split on comma and trim
cvec_c_tr <- function(x) {
  if(is.null(x) | length(x)==0) return(character(0))
  x <- unlist(strsplit(as.character(x),",",fixed=TRUE),use.names=FALSE)
  x <- gsub("^\\s+|\\s+$", "",x, perl=TRUE)
  x <- x[x!=""]
  if(length(x)==0) {
    return(character(0))
  } else {
    return(x)
  }
}

## Create a character vector
## Split on comma and rm whitespace
cvec_c_nws <- function(x) {
  if(is.null(x) | length(x)==0) return(character(0))
  x <- unlist(strsplit(as.character(x),",",fixed=TRUE),use.names=FALSE)
  x <- gsub(" ", "",x, fixed=TRUE)
  x <- x[x!=""]
  if(length(x)==0) {
    return(character(0))
  } else {
    return(x)
  }
}



nonull <- function(x,...) UseMethod("nonull")
##' @export
nonull.default <- function(x,...) x[!is.null(x)]
##' @export
nonull.list <- function(x,...) x[!sapply(x,is.null)]

s_pick <- function(x,name) {
  stopifnot(is.list(x))
  nonull(unlist(sapply(x,"[[",name)))
}

ll_pick <- function(x,name) {
  stopifnot(is.list(x))
  lapply(x,"[[",name)
}

l_pick <- function(x,name) {
  stopifnot(is.list(x))
  lapply(x,"[",name)
}
s_quote <- function(x) paste0("\'",x,"\'")
d_quote <- function(x) paste0("\"",x,"\"")


charcount <- function(x,w,fx=TRUE) {
  nchar(x) - nchar(gsub(w,"",x,fixed=fx))
}

charthere <- function(x,w,fx=TRUE) {
  grepl(w,x,fixed=fx)
}

where_is <- function(what,x) {
  as.integer(unlist(gregexpr(what,x,fixed=TRUE)))
}

where_first <- function(what,x) {
  as.integer(unlist(regexpr(what,x,fixed=TRUE)))
}

example <- function(x) {
  file <- file.path("yaml",paste0(x,".yaml"))
  system.file(file,package="mrgsim")
}

#
# eval_ENV_block <- function(x,where,envir=new.env(),...) {
#   .x <- try(eval(parse(text=x),envir=envir))
#   if(inherits(.x,"try-error")) {
#     stop("Failed to parse code in $ENV",call.=FALSE)
#   }
#   envir$.code <- x
#   return(envir)
# }
