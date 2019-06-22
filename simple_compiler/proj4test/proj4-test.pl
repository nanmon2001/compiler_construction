#!/usr/bin/perl -w

# Perl script for testing CSCE 531 project 4 submissions (pointers and arrays)

# Usage (can be run in any working directory):
# $ proj4-test.pl --self-test

# Writes to file "comments.txt" in your project directory
# ($project_directory, defined below)

# This script must be run under the bash shell!

# edit as needed

# This project directory (below) should be the common parent of two
# subdirectories:
#     proj4 -- contains the source files of your submission
#     proj4test -- contains the test files T4L*.c
# The script will run "make" in the proj4 subdirectory, then run the resulting
# executable on files in the proj4test subdirectory, putting the output files
# in the proj4 (source) directory. For each error-free file, it then tries to
# assemble each .s file using "gcc",
# linking it with a library if necessary, to produce the executable a.out.
# This executable is then run, with standard input redirected from a .in file
# if appropriate, and standard output redirected to a .out file. This .out
# file is then compared with the one in the proj4test directory.
# For each file with errors, only you compiler's output to standard error
# is collected (the assembly output is ignored) and displayed.
# Comments are placed in the project directory in the file "comments.txt".
#
# The project directory should be an ABSOLUTE path name
# ($ENV{HOME} expands to your home directory). It is currently set
# to the place where I keep the test files in my own account.
$project_directory = "$ENV{HOME}/public_html/csce531/handouts";
$semester = 'sp17';

# This default bison message varies by system or configuration
# On CSE Linux systems in the labs
# $bison_parse_error_msg = "syntax error";
# On my Mac
# $bison_parse_error_msg = "parse error";

############ You should not have to edit below this line ##############

$project_installment = 4;
$hw_dir = "proj$project_installment";
$test_suite_dir = "$project_directory/${hw_dir}test";
$submission_root = "$ENV{HOME}/courses/csce531/$semester/proj${project_installment}/submissions";
$test_file_prefix = "T${project_installment}L";
$timeout = 11;			# seconds
$prog_name = 'pcc3';

# Which library to use for which level
%lib_files = (
    '80' => 'lib80',
    '90' => 'lib90',
    '100' => 'lib100'
);

# Hash to hold the test results
%error_counts = ();

# Check existence of project directory
die "No project directory $project_directory\n"
    unless -d $project_directory;

# Check existence of source code directory
die "No executable directory $project_directory/$hw_dir\n"
    unless -d "$project_directory/$hw_dir";

# Check existence of test suite directory
die "No test suite directory $test_suite_dir\n"
    unless -d $test_suite_dir;

#sub main
{
    $project_directory =~ /^\//
	or die "Project dir pathname $project_directory is not absolute\n";

    # Get C source test files
    opendir DIR, $test_suite_dir;
    my @filenames = readdir DIR;
    my @testfilenames = ();
    while (@filenames) {
        $name = shift @filenames;
	next if $name !~ /^($test_file_prefix.*)\.c$/;
	push @testfilenames, ($1);
    }

    # Typical element is $test_file_hash{$level}->{$ok_or_err} = $base
    %test_file_hash = ();

    foreach $base (@testfilenames) {
	$base =~ /^$test_file_prefix(\d+[^_]*)_(err|ok)$/;
	$test_file_hash{$1}{$2} = $&;
    }

    # Get execution test files
    opendir DIR, "$test_suite_dir/out";
    @filenames = readdir DIR;
    @testfilenames = ();
    while (@filenames) {
        $name = shift @filenames;
	next if $name !~ /^($test_file_prefix.*)_ok\.out$/;
	push @testfilenames, ($1);
    }

    # Typical element is $test_exec_out_hash{$level} = $base
    %test_exec_out_hash = ();
    # similar
    %test_exec_in_hash = ();

    foreach $base (@testfilenames) {
	$base =~ /^$test_file_prefix(.*)$/;
	$test_exec_out_hash{$1} = $base;
	if (-e "$test_suite_dir/out/${base}_ok.in") {
	    $test_exec_in_hash{$1} = $base;
	}
    }

    if (@ARGV && $ARGV[0] eq '--self-test') {
	$uname = 'self-test';
	process_user();
    }
    elsif (@ARGV) {
	while (@ARGV) {
	    $uname = shift @ARGV;
	    process_user();
	}
    }
    else {
	opendir DIR, $submission_root
	    or die "Cannot open submission directory $submission_root ($!)\n";
	@usernames = readdir DIR;
	closedir DIR;

	while (@usernames) {
	    $uname = shift @usernames;
	    next if $uname =~ /^\./;
	    next unless -d "$submission_root/$uname";
	    process_user();
	}
    }
}


sub process_user {
    print(STDERR "Processing $uname/$hw_dir\n\n");
    if ($uname eq 'self-test') {
	$udir = "$project_directory";
    }
    else {
	$udir = "$submission_root/$uname";
    }
    die "No subdirectory corresponding to $uname ($!)\n"
	unless -d $udir;

    open(COMMENTS, "> $udir/comments.txt");

    cmt("Comments for $uname -------- " . now() . "\n");

    chdir $udir;

    if (!(-d $hw_dir)) {
	cmt("  No $hw_dir subdirectory found\n");
	close COMMENTS;
	return;
    }

    chdir $hw_dir
	or die "Cannot change to $udir/$hw_dir directory ($!)\n";

    # try make clean, regardless of what happens
    system("make", "clean");

    opendir DIR, "$udir/$hw_dir"
	or die "Cannot open $udir/$hw_dir directory ($!)\n";
    @filenames = readdir DIR;
    closedir DIR;
    $count = 0;
    while (@filenames) {
	$filename = shift @filenames;
	chomp $filename;
	next if $filename =~ /^\./;
	if ($filename =~ /^lex\.yy|^y\.tab|\.o$|^parse\.c$|^scan\.c$|^ppc3$/) {
	    cmt("Removing illegal file: $filename\n");
	    unlink $filename;
	    $count++;
	}
    }
    cmt("No illegal files found\n")
	if $count == 0;

    %error_counts = ();

    print(STDERR "\nTesting compile ...\n");
    test_compiler($prog_name);

    report_compiler_summary();

    %error_counts = ();

    print(STDERR "\n\nTesting execution ...\n");
    test_execution($prog_name);

    report_execution_summary();

    close COMMENTS;

    # try cleaning -- don't care what happens
    system("make", "clean");

    if ($uname eq 'self-test') {
	print(STDERR "\nDone.\nComments are in comments.txt\n");
    }
    else {
	print(STDERR "\nDone.\nComments are in $uname/comments.txt\n");
    }
}


sub test_compiler {
    my ($prog) = @_;

    print(STDERR "\nCompiling: error msgs for $uname/$prog:\n");
    print(STDOUT "\nCompiling: system msgs for $uname/$prog:\n");

    cmt("\nTesting compilation with $prog:\n");

    $error_counts{$prog} = 0;

    $rc = test_make($prog);

    if (!$rc) { # if couldn't make original prog
	cmt("Make of $prog failed\n");
	$error_counts{$prog}++;
	return;
    }

    foreach $level (sort by_extracted_number (keys(%test_file_hash))) {

	cmt("\n\nLEVEL $level:\n\n");

	foreach $key (sort { $b cmp $a; } (keys(%{$test_file_hash{$level}}))) {

	    $base = $test_file_hash{$level}{$key};

	    -e "$test_suite_dir/$base.c" || die "$base.c does not exist ($!)\n";
	    cmt("Running $prog with input $base.c ...");
	    print(STDERR "----$base.c:\n");
	    $testFile = "$test_suite_dir/$base.c";
	    unlink "$base.s"
		if -e "$base.s";
	    unlink "$base.err"
		if -e "$base.err";
	    $error_counts{$base} = 0;
	    eval {
		local $SIG{ALRM} = sub { die "timed out\n" };
		alarm $timeout;
		$rc = system("./$prog < $testFile > $base.s 2> $base.err");
		alarm 0;
	    };
	    if ($@ && $@ eq "timed out\n") {
		cmt(" $@");		# program timed out before finishing
		$error_counts{$base}++;
		next;
	    }
	    elsif ($rc >> 8) {
		cmt(" nonzero termination status\n");
	    }
	    else {
		cmt(" zero termination status\n");
	    }

	    # Test error file in any case
	    if ($base =~ /_err$/ && -e "$base.err") {
		cmt("  $base.err exists\n  Comparing with solution file ...");
		$report = `diff $base.err $test_suite_dir/out/$base.err`;
		chomp $report;
		if ($report eq '') {
		    cmt(" files match\n");
		}
		else {
		    cmt(" files differ:\nvvvvv\n$report\n^^^^^\n");
		    $error_counts{$base}++;
		}
	    }
	    elsif (-e "$base.err") {   # testing with error-free source
		$report = `cat $base.err`;
		chomp $report;
		if ($report ne '') {
		    cmt("  errors reported:\nvvvvv\n$report\n^^^^^\n");
		    $error_counts{$base}++;
		}
	    }
	    elsif ($base =~ /_err$/) {
		cmt("  No error output for $base\n");
		$error_counts{$base}++;
	    }

	    next if ($base =~ /_err$/);

	    # At this point, C source is error-free.

	    if (!(-e "$base.s")) {
		cmt("  output file $base.s does not exist\n");
		$error_counts{$base}++;
		next;
	    }

	    cmt("  $base.s exists ... will assemble and run later\n");

            # cmt("  Comparing backend command sequence with solution ...");
            # $rc = system("/class/csce531-001/handouts/get-backend-commands.pl < $base.s > $base.strip");
            # if ($rc >> 8) {
	    #    die "An error occurred fetching backend commands ($1)\n";
            # }
            # $report = `diff $base.strip $testSuiteDir/out/$base.strip`;
            # chomp $report;
            # if ($report eq '') {
	    #     cmt(" files match\n");
	    #     next;
            # }
            # cmt(" files differ:\nvvvvv\n$report\n^^^^^\n");
            # $error_counts{$base}++;
        }
    }
}


sub test_execution {
    my ($prog) = @_;

    print(STDERR "Execution: error msgs for $uname/$prog:\n");
    print(STDOUT "Execution: system msgs for $uname/$prog:\n");

    cmt("\nTesting execution with $prog:\n");

    $error_counts{$prog} = 0;

    foreach $level (sort by_extracted_number (keys(%test_exec_out_hash))) {

	cmt("\n\nLEVEL $level:\n\n");

	$base = $test_exec_out_hash{$level};
	$error_counts{$base} = 0;

	-e "$test_suite_dir/out/${base}_ok.out" || die "${base}_ok.out does not exist ($!)\n";
	print(STDERR "----$base:\n");

	if (!(-e "${base}_ok.s")) {
	    cmt("Assembly file ${base}_ok.s does not exist\n");
	    $error_counts{$base}++;
	    next;
	}
	    
	unlink "a.out"
	    if -e "a.out";

	cmt("Trying to assemble ${base}_ok.s with gcc ");
	if (exists($lib_files{$level})) {
	    cmt("and $lib_files{$level} ... ");
	    $rc = system("gcc", "-m32", "${base}_ok.s", "$test_suite_dir/$lib_files{$level}.o");
	}
	else {
	    cmt("... ");
	    $rc = system("gcc", "-m32", "${base}_ok.s");
	}
	if ($rc >> 8) {
	    cmt(" failed\n");
	    $error_counts{$base}++;
	}
	else {
	    cmt(" succeeded\n");
	}

	if (-e "a.out") {
	    cmt("Executable a.out exists\n");
	}
	else {
	    cmt("Executable a.out does not exist\n");
	    next;
	}

	$testFile = "$test_suite_dir/out/${base}_ok.in";
	eval {
	    local $SIG{ALRM} = sub { die "timed out\n" };
	    alarm $timeout;
	    if (-e $testFile) {
	        cmt("./a.out < ${base}_ok.in > ${base}_ok.out 2> ${base}_ok_exec.err");
		$rc = system("./a.out < $testFile > ${base}_ok.out 2> ${base}_ok_exec.err");
	    }
	    else {
	        cmt("./a.out > ${base}_ok.out 2> ${base}_ok_exec.err");
		$rc = system("./a.out > ${base}_ok.out 2> ${base}_ok_exec.err");
	    }
	    alarm 0;
	};
	if ($@ && $@ eq "timed out\n") {
	    cmt(" $@");		# program timed out before finishing
	    $error_counts{$base}++;
	    next;
	}
	elsif ($rc >> 8) {
	    cmt(" terminated abnormally\n");
	    # $error_counts{$base}++;
	    if (-e "${base}_ok_exec.err") {
		cmt("  Standard error output:\nvvvvv\n");
		$report = `cat ${base}_ok_exec.err`;
		chomp $report;
		cmt("$report\n^^^^^\n");
	    }
	}
	else {
	    cmt(" terminated normally\n");
	    if (-e "${base}_ok_exec.err") {
		cmt("  Standard error output:\nvvvvv\n");
		$report = `cat ${base}_ok_exec.err`;
		chomp $report;
		cmt("$report\n^^^^^\n");
	    }
	}

	if (!(-e "${base}_ok.out")) {
	    cmt("  output file ${base}_ok.out does not exist\n");
	    $error_counts{$base}++;
	    next;
	}

	cmt("  ${base}_ok.out exists -- comparing with solution output file\n");
	$report = `diff ${base}_ok.out $test_suite_dir/out/${base}_ok.out`;
	chomp $report;
	if ($report eq '') {
	    cmt(" files match\n");
	    next;
	}
	cmt(" files differ:\nvvvvv\n$report\n^^^^^\n");
	$error_counts{$base}++;
    }
}



# Tries to make the given executable program.  Returns true iff success
sub test_make {
    my ($prog) = @_;
    my $execFile = "$prog";

    cmt("  Attempting to build $prog ...");
    $rc = system("make", "-B", $prog);
    if ($rc >> 8) {
	cmt(" make -B $prog failed\n");
	return 0;
    }

    if (!(-e $execFile)) {
	cmt(" $prog executable does not exist\n");
	return 0;
    }

    cmt(" ok\n");
    return 1;
}


sub report_compiler_summary {
    cmt("######################################################\n");
    cmt("Compilation summary for $uname:\n");

    foreach $base (sort(keys %error_counts)) {
	cmt("  $base: ");
	$cnt = $error_counts{$base};
	if ($cnt > 0) {
	    cmt(" problem(s) found");
	}
	elsif ($base !~ /_err$/) {
	    cmt(" ok");
	}
	else {
	    cmt(" error message(s) (will check appropriateness by hand)");
	}
	cmt("\n");
    }
    cmt("######################################################\n");
    # cmt(" 80% level: (supplied by hand)\n");
    # cmt(" 90% level: (supplied by hand)\n");
    # cmt("100% level: (supplied by hand)\n");
}


sub report_execution_summary {
    cmt("######################################################\n");
    cmt("Assembly/execution summary for $uname:\n");

    foreach $base (sort(keys %error_counts)) {
	cmt("  $base: ");
	$cnt = $error_counts{$base};
	if ($cnt > 0) {
	    cmt(" problem(s) found");
	}
	elsif ($base !~ /_err$/) {
	    cmt(" ok");
	}
	else {
	    cmt(" error message(s) (will check appropriateness by hand)");
	}
	cmt("\n");
    }
    cmt("######################################################\n");
    cmt(" 80% level: (supplied by hand)\n");
    cmt(" 90% level: (supplied by hand)\n");
    cmt("100% level: (supplied by hand)\n");
}


sub cmt {
    my ($str) = @_;
#  print $str;
    print(COMMENTS $str);
}


sub now {
    my $ret;

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;
    $ret = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat')[$wday];
    $ret .= " ";
    $ret .= ('Jan','Feb','Mar','Apr','May','Jun','Jul',
	     'Aug','Sep','Oct','Nov','Dec')[$mon];
    $ret .= " $mday, ";
    $ret .= $year + 1900;
    $ret .= " at ${hour}:${min}:${sec} ";
    if ( $isdst ) {
	$ret .= "EDT";
    } else {
	$ret .= "EST";
    }
    return $ret;    
}


sub by_extracted_number
{
    my ($n1,$n2);
    $a =~ /^\d+/;
    $n1 = $&;
    $b =~ /^\d+/;
    $n2 = $&;
    $n1 <=> $n2;
}
