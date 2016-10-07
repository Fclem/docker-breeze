lib_loc <- '~/appl_taito/R_LIBS'

# dynamically load a library, and install it if non existant
load_lib <- function(lib){
	txt <- as.character(substitute(lib))
	my_stop <- function(e){ stop(e) }
	do_load <- function(lib){
		cat(c('Loading', txt, '...'))		
		tryCatch( require(lib, character.only=TRUE), error=my_stop )
		cat(' done !\n')
	 }
	tryCatch(do_load(lib),error = function(e){
		print(e)
		cat(c('Lib', txt, 'not found, installing...\n'))
		cat("Using Estonia repository\n")
		r = getOption("repos")
		r["CRAN"] = "http://ftp.eenet.ee/pub/cran/"
		options(repos = r)
		rm(r)
		tryCatch( install.packages(lib, lib=lib_loc), error=my_stop, warning=my_stop )
		cat(c('Lib', txt, 'installed !\n'))
		do_load(lib)
	})
}

# load_lib('lib_name')
