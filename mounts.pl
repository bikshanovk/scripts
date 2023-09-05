#!/usr/bin/perl
 
$first = 1;
 
print "[\n";
 
for (`cat /proc/mounts`)
{
    ($fsname, $fstype) = m/\S+ (\S+) (\S+)/;
 
    print "\t,\n" if not $first;
    $first = 0;
 
    print "\t{\n";
    print "\t\t\"fsname\":\"$fsname\",\n";
    print "\t\t\"fstype\":\"$fstype\"\n";
    print "\t}\n";
}
 
print "]\n";
