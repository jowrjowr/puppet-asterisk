module Asterisk =
  autoload xfm

(************************************************************************
 * INI File settings
 *
 * asterisk.conf only supports "; as commentary and "=" as separator
 *************************************************************************)
let comment    = IniFile.comment ";" ";"
let sep        = IniFile.sep "=" "="

(************************************************************************
 *                        ENTRY
 * puppet.conf uses standard INI File entries
 *************************************************************************)
let entry   = IniFile.indented_entry IniFile.entry_re sep comment


(************************************************************************
 *                        RECORD
 * puppet.conf uses standard INI File records
 *************************************************************************)
let title   = IniFile.indented_title IniFile.record_re
let record  = IniFile.record title entry


(************************************************************************
 *                        LENS & FILTER
 * puppet.conf uses standard INI File records
 *************************************************************************)
let lns     = IniFile.lns record comment

let filter = (incl "indications.conf")

let xfm = transform lns filter