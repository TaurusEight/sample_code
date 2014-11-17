###
changequote(`[',`]')dnl
define([INFO],[ifdef([DEBUG],[Log.info( $1)],[])])dnl
define([WARN],[ifdef([DEBUG],[Log.warn( $1)],[])])dnl
define([ERROR],[ifdef([DEBUG],[Log.error( $1)],[])])dnl
###
