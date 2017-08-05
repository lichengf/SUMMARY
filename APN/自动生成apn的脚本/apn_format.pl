
open(FILE,"<","India_APN.csv")||die"cannot open the file: $!\n";

open(FileHandler, ">apns-conf_8.xml")|| die $!;

$num = 1;

while (<FILE>) {
	@apn_line = split(/,/, $_);
	my $apn_line_length = @apn_line;
	$apn_line[5] =~ s/\//\,/g;
	$apn_line[9]=~ s/\*//g;
	$apn_line[10]=~ s/\*//g;
	$apn_line[13]=~ s/\*//g;
	$apn_line[14]=~ s/\n//g;
	$single_line = "<apn carrier=\"$apn_line[1]\"
	mcc=\"$apn_line[2]\"
	mnc=\"$apn_line[3]\"
	apn=\"$apn_line[4]\"
	type=\"$apn_line[5]\"
	mmsc=\"$apn_line[6]\"
	mmsproxy=\"$apn_line[7]\"
	mmsport=\"$apn_line[8]\"
	user=\"$apn_line[9]\"
	password=\"$apn_line[10]\"
	proxy=\"$apn_line[11]\"
	port=\"$apn_line[12]\"
	server=\"$apn_line[13]\"
	authtype=\"$apn_line[14]\"
	editable=\"0\"
	\/>";
	
    #print ("$apn_line[14]\n");
	$num++;
	print "$num/\n";
	print FileHandler "$single_line\n";
}
close FileHandler;
close FILE;
