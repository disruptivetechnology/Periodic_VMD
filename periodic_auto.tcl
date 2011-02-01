###############################################################
#                                                             #
#  		        - Periodic Auto -		      #
#			periodic_auto.tcl                     #
#                                                             #
# Brett Donovan,        Jan 2011                              #
#                                                             #
# Pull in cell size information from the unit cell for        #
# file formats XYZ such as OpenMD, where cell dimensions are  #
# found in header of each frame, but are not amenable to      #
# calls within VMD. You will then be able to view periodic    #
# images. (VMD: Representations->Periodic tab).		      #
#                                                             #          
#                                                             #
###############################################################
#pick ID for current molecule


# Load in your file here with frame data
set fp [open "Membrane_Therm.xyz" r]
     set file_data [read $fp]
     close $fp

set count 0
set start 0
set NumberAtoms 0
set frames 0

set data [split $file_data "\n"]
     foreach line $data {
	if {$line == $NumberAtoms & $start == 1} {
		set count 0
		set frames [expr {$frames+1}]
	}

        if {$count == 0} {
		set NumberAtoms $line
		set start 1
	}
	set count [expr {$count + 1}]
	if {$count == 2} {
		set line [string map {";" ""} $line]
		set wordList [regexp -all -inline {\S+} $line]
		set a [lindex $wordList 1]
		set b [lindex $wordList 5]
		set c [lindex $wordList 9]
		set array($frames) "$a $b $c"		
	}
     }



set molid [molinfo top]
set n   [molinfo $molid get numframes]

# Loop through all frames
    for {set i 0} {$i < $n} {incr i} {
	set abc $array($i)
	puts "$a $b $c"
	set a [lindex $abc 0]
	set b [lindex $abc 1]
	set c [lindex $abc 2]
        molinfo $molid set frame $i
        molinfo $molid set a $a
        molinfo $molid set b $b
        molinfo $molid set c $c
        molinfo $molid set alpha 90.000
        molinfo $molid set beta 90.000
        molinfo $molid set gamma 90.000
    }

animate goto start

