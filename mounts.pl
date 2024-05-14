#!/usr/bin/perl

use Config;

$first = 1;

if ( "$Config{osname}" eq "linux" ) {
    print "[\n";
    for (`cat /proc/mounts`) {
        
        ($fsname, $fstype) = m/\S+ (\S+) (\S+)/;
        
        print "\t,\n" 
        if not $first; $first = 0;
    
        print "\t{\n";
        print "\t\t\"fsname\":\"$fsname\",\n";
        print "\t\t\"fstype\":\"$fstype\"\n";
        print "\t}\n";
    }
    print "]\n";
} else {
    print "\nerror : this script only works on linux\n"
}
