#-------------------------------------------------------------------------------
# PACKAGE : Bio::Tools::Fasta.pm
# PURPOSE : To encapsulate code for parsing Fasta sequence files
#           and eventually for parsing, analyzing, running Fasta analyses.
# AUTHOR  : Steve A. Chervitz (sac@genome.stanford.edu)
# CREATED : 27 Mar 1998
# REVISION: $Id$
# STATUS  : Alpha
#
# For documentation, run this module through pod2html 
# (preferably from Perl v5.004 or better).
#
# MODIFICATION NOTES:  See bottom of file.
#
#-------------------------------------------------------------------------------

package Bio::Tools::Fasta;
use strict;

BEGIN {
   warn "Deprecation Warning: $0 uses Bio::Tools::Fasta.pm.\n" .
        "This module has been deprecated. Use the Bio::SeqIO system instead.\n\n";
}

use Bio::Tools::SeqAnal;
use Bio::Root::Global     qw(:std);
use Bio::Root::Utilities  qw(:obj); 

use vars qw(@ISA @EXPORT @EXPORT_OK %EXPORT_TAGS
            $ID $VERSION $Fasta $RawData $Newline);

@ISA        = qw( Bio::Tools::SeqAnal Exporter);
@EXPORT     = qw();
@EXPORT_OK  = qw($VERSION $Fasta);
%EXPORT_TAGS = ( obj => [qw($Fasta)],
		 std => [qw($Fasta)]);

$ID = 'Bio::Tools::Fasta';
$VERSION  = 0.014; 


## Static FASTA object. 
$Fasta = {};
bless $Fasta, $ID;
$Fasta->{'_name'} = "Static Fasta object";

$RawData = '';


## POD Documentation:

=head1 NAME

Bio::Tools::Fasta.pm - Bioperl Fasta utility object

=head1 INSTALLATION

This module is included with the central Bioperl distribution:

   http://bio.perl.org/Core/Latest
   ftp://bio.perl.org/pub/DIST

Follow the installation instructions included in the README file.

=head1 SYNOPSIS

=head2 Object Creation

Bio::Tools::Fasta.pm cannot yet build sequence analysis objects given output from 
the FASTA program. This module can only be used for parsing Fasta multiple sequence
files. This situation may change.

=head2 Parse a Fasta multiple-sequence file.

If $file is not a valid filename, data will be read from STDIN.
See the L<parse>() method for a complete description of parameters.

    use Bio::Tools::Fasta qw(:obj);

    $seqCount = $Fasta->parse(-file        => $file,
			      -seqs        => \@seqs,
			      -ids         => \@ids,
			      -edit_id     => 1,
			      -edit_seq    => 1,
			      -descs       => \@descs,
			      -filt_func   => \&filter_seq   # filter input sequences.
			      -exec_func   => \&process_seq  # process each seq as it is parsed.
			      );

=head1 DESCRIPTION

The Bio::Tools::Fasta.pm module, in its present incarnation, encapsulates data 
and methods for managing Fasta multiple sequence files (reading, parsing).
It does not yet work with output from the Fasta sequence analysis program
(L<References & Information about the FASTA program>).

The documentation of this module is incomplete. For some examples of
usage, see the B<DEMO SCRIPTS> section.

Unlike "Blast", the term "Fasta" is ambiguous since it refers to 
both a sequence file format and a sequence analysis utility
(I use "FASTA" to refer to the program; "Fasta" for the file format).
Ultimately, this module will be able to work with both
Fasta sequence files as well as result files 
generated by FASTA sequence analysis, analogous to the way the
B<Bio::Tools::Blast.pm> object is used for working with Blast output.


=head2 References & Information about the FASTA program

B<WEBSITES:>

   ftp://ftp.virginia.edu/pub/fasta/    - FASTA software
   http://www2.ebi.ac.uk/fasta3/        - FASTA server at EBI


B<PUBLICATIONS:> (with PubMed links)

  Pearson W.R. and Lipman, D.J. (1988). Improved tools for biological
  sequence comparison. PNAS 85:2444-2448

http://www.ncbi.nlm.nih.gov/htbin-post/Entrez/query?uid=3162770&form=6&db=m&Dopt=b

  Pearson, W.R. (1990). Rapid and sensitive sequence comparison with FASTP and FASTA.
  Methods in Enzymology 183:63-98.

http://www.ncbi.nlm.nih.gov/htbin-post/Entrez/query?uid=2156132&form=6&db=m&Dopt=b

=head1 USAGE

A simple demo script is included with the central Bioperl distribution (L<INSTALLATION>)
and is also available from:

    http://bio.perl.org/Core/Examples/seq/

=head1 DEPENDENCIES

Bio::Tools::Fasta.pm is a concrete class that inherits from B<Bio::Tools::SeqAnal.pm>.
This module also relies on B<Bio::Seq.pm> for producing sequence objects.


=head1 FEEDBACK

=head2 Mailing Lists 

User feedback is an integral part of the evolution of this and other Bioperl modules.
Send your comments and suggestions preferably to one of the Bioperl mailing lists.
Your participation is much appreciated.

  bioperl-l@bioperl.org                  - General discussion
  http://www.bioperl.org/MailList.shtml  - About the mailing lists

=head2 Reporting Bugs

Report bugs to the Bioperl bug tracking system to help us keep track the bugs and 
their resolution. Bug reports can be submitted via email or the web:

    bioperl-bugs@bio.perl.org                   
    http://bio.perl.org/bioperl-bugs/           

=head1 AUTHOR

Steve A. Chervitz, sac@genome.stanford.edu

=head1 VERSION

Bio::Tools::Fasta.pm, 0.014

=head1 COPYRIGHT

Copyright (c) 1998 Steve A. Chervitz. All Rights Reserved.
This module is free software; you can redistribute it and/or 
modify it under the same terms as Perl itself.

=head1 SEE ALSO

  Bio::Tools::SeqAnal.pm   - Sequence analysis object base class.
  Bio::Seq.pm              - Biosequence object  
  Bio::Root::Object.pm     - Proposed base class for all Bioperl objects.

  http://bio.perl.org/Projects/modules.html  - Online module documentation
  http://bio.perl.org/                       - Bioperl Project Homepage

L<References & Information about the FASTA program>.

=head1 TODO

=over 4

=item * Incorporate code for parsing Fasta sequence analysis reports.

=item * Improve documentation.

=back

=cut


#
##
###
#### END of main POD documentation.
###
##
#

=head1 APPENDIX

Methods beginning with a leading underscore are considered private
and are intended for internal use by this module. They are
B<not> considered part of the public interface and are described here
for documentation purposes only.

=cut

##############################################################################
##                          CONSTRUCTOR                                     ##
##############################################################################

=head2 _initialize

 Usage     : n/a; automatically called by Bio::Root::Object::new()
 Purpose   : Calls superclass constructor.
 Returns   : n/a
 Argument  : Named parameters passed to new() are processed by this method.
           : At present, none are processed.

See Also   : B<Bio::Tools::SeqAnal::_initialize()>

=cut

#----------------
sub _initialize {
#----------------
    my( $self, @param ) = @_;
    
    # Nothing fancy yet.

    $self->SUPER::_initialize( @param );
}



#####################################################################################
##                                  ACCESSORS                                      ##
#####################################################################################


=head2 parse

 Usage     : $fasta_obj->$parse( %named_parameters)
 Purpose   : Parse a set of Fasta sequences or Fasta reports from a file or STDIN.
           : (Currently only Fasta sequence parsing is supported).
 Returns   : Integer (number of sequences or Fasta reports parsed).
 Argument  : Named parameters: (TAGS CAN BE UPPER OR LOWER CASE)
	   :   -FILE       => string (name of file containing Fasta-formatted sequences.
           :                          Optional. If a valid file is not supplied, 
	   :			      STDIN will be used).
           :   -SEQS       => boolean (true = parse a Fasta multi-sequence file
           :                           false = parse a Fasta sequence analysis report).
           :   -IDS        => array_ref (optional).
           :   -DESCS      => array_ref (optional).
           :   -EDIT_ID    => boolean  (true = edit sequence identifiers).
           :   -EDIT_SEQ   => boolean  (true = edit sequence data).
           :   -TYPE       => string   (type of sequences to be processed: 
           :                            'dna', 'rna', 'amino'),
           :   -FILT_FUNC  => func_ref (reference to a function for filtering out
	   :				sequences as they are being parsed. 
	   :				This function should return a boolean
           :                            (true if the sequence should be filtered out)
	   :				and accept three arguments as shown 
	   :				in this sample filter function:
	   :				sub filt { 
	   :				    my($len, $id, $desc);
	   :				    # $len is the sequence length
	   :				    return ($len < 25 and $id =~ /^123/);
	   :				}
           :                            This function will screen out any sequence
           :                            less than 25 in length and having an id
	   :				starting with '123'.
           :   -SAVE_ARRAY => array_ref (reference to an array for storing all
           :                             sequence objects as they are created.)
           :   -EXEC_FUNC  => func_ref (reference to a function for processing each 
           :                            sequence object) as it is parsed.
           :                            When working with sequences, this function 
           :                            should accept a Bio::Seq.pm object as its 
           :                            sole argument. Return value will be ignored).
           :   -STRICT     => boolean (increases sensitivity to errors).
           :
           :  ----------------------------------------------------------------
           :   NOTE: Parameters such as seqs, ids, desc, edit_id, edit_seq, type
           :         are used only when parsing Fasta sequence files.
           :         Additional parameters will be added as necessary for
           :         parsing Fasta sequence analysis reports.
           :
	   :   NOTE: When retreiving sequence data instead of objects,
           :         the -SEQS, -IDS, and -DESCS parameters should all be array refs.
           :         This constitutes a signal that sequence objects are not 
           :         to be constructed.
           :
 Throws    : Propagates any exceptions thrown by _parse_seq_stream()
 Comments  : 

  WORKING WITH SEQUENCE DATA:
  ---------------------------
  The parse method can return sequence data bundled into Bio::Seq.pm objects 
  or in raw format (separate arrays for seq, id, and desc data). The reason for
  this is that in some cases, you don't particularly need to work with sequence
  objects and it is inefficient to build objects just to have them broken apart. 
  However, there is something to be said for choosing one approach -- 
  always return seq objects. In this way, the object 
  becomes the basic unit of exchange. For now, both options are allowed.

  The story will be different for Fasta sequence analysis report objects
  since these are a much more complex data type and it would be unwieldy
  and dangerous to return parsed data unencapsulated from an object.

See Also   : L<_parse_seq_stream>(), L<_set_id_desc>(), L<_get_parse_seq_func>()

=cut

#-----------'
sub parse {
#-----------
    my ($self, %param) = @_;

    ## If the static $Fasta object is being used, we need to handle some
    ## issues that would normally be handled by the constructor.

    my($seqs, $strict) = $self->_rearrange([qw(SEQS STRICT)], %param);

    $self->strict($strict) if $strict;

    my ($count);
    if($seqs) {
	# Parse a Fasta multiple-sequence file.
	$count = $self->_parse_seq_stream(%param);
	
    } else {
	# Parse a Fasta sequence analysis report.
	# Currently not supported.
	# See Bio::Tools::Blast::parse() for a general strategy.
	$self->throw("Can't parse Fasta data.",
		     "Only Fasta sequence file parsing is currently supported.");

    }
    $RawData = '';
    $count;
}


=head2 _parse_seq_stream

 Usage     : n/a. Internal method called by parse()
 Purpose   : Obtains the function to be used during parsing and calls read().
 Returns   : Integer (the number of sequences read)
 Argument  : Named parameters  (forwarded from parse())
 Throws    : Propagates any exception thrown by _get_parse_seq_func() and read().
 Comments  : 

  This method permits the sequence data to be parsed as it is being read in. 
  The motivation here is that when working with a potentially huge set of
  sequences, there is no need to read them all into memory before you start
  processing them. In fact, you may only be interested in a few of them.
 
  This method constructs and returns a closure for parsing a single Fasta sequence.
  It is called automatically by the read() method inherited from 
  Bio::Root::Object.pm. 
 
  Another issue concerns what to do with the parsed data: save it or
  use it? Sometimes you need to process all sequence data as a group
  (eg., sorting). Other times, you can safely process each sequence
  as it gets parsed and then move on to the next. By delivering each
  sequence as it gets parsed, the client is free to decide what to
  do with it.

See Also   : L<_get_parse_seq_func>(), B<Bio::Root::Object::read()>

=cut

#----------------------
sub _parse_seq_stream {
#----------------------
    my ($self, %param) = @_;

    my $func = $self->_get_parse_seq_func(%param);

    $self->{'_seqCount'} = 0;

    # Only setting the newline character once for efficiency.
    $Newline ||= $Util->get_newline(-client => $self, %param);

    $self->read(-REC_SEP  =>"$Newline>", 
		-FUNC     => $func,
		%param);

    return $self->{'_seqCount'};
    
}



=head2 _get_parse_seq_func

 Usage     : n/a. Internal method called by _parse_seq_stream()
 Purpose   : Generates a function reference to be used for parsing raw sequence data
           : as it is being loaded by read().
           : Used when parsing Fasta sequence files.
 Returns   : Function reference (actually a closure)
 Argument  : Named parameters forwared from _parse_seq_stream()
 Throws    : Exceptions due to improper argument types.
           :   (to be elaborated...)
 Comments  : The function generated performs sequence editing if
           : the -EDIT_SEQ parse() parameter is is non-zero.
	   : This consists of removing any ambiguous residues at begin 
           : or end of seq.
	   : Regardless of -EDIT_SEQ, all sequence will be edited to remove
           : whitespace and non-alphabetic chars.
	   : Gaps characters are permitted ('.' and '-').
           : (Need a more universal way to identify gap characters.)
           : If sequence objects are generated and an -EXEC_FUNC is supplied,
           : each object will be destroyed after calling this function.
           : This prevents memory usage problems for large runs.

See Also   : L<parse>(), L<_parse_seq_stream>(), B<Bio::Root::Object::_rearrange>()

=cut

#------------------------
sub _get_parse_seq_func {
#------------------------
    my ($self, %param) = @_;

    my ($seq_a, $id_a, $desc_a, $edit_id, $edit_seq, $type, $strict, 
	$filt_func, $save_a, $exec_func) = 
	$self->_rearrange([qw(SEQS IDS DESCS EDIT_ID EDIT_SEQ TYPE STRICT 
			      FILT_FUNC SAVE_ARRAY EXEC_FUNC)], %param); 

    $self->edit_id($edit_id);
    $edit_seq = $self->edit_seq($edit_seq);
    $strict ||= $self->strict();
    $type ||= 0;
    my $nucl = (($type =~ /[DR]na/i) || 0);
    my $get_obj = not ($seq_a and $id_a and $desc_a);

    # Some validation:
    if($filt_func and not ref($filt_func) eq 'CODE') {
	$self->throw("The -FILT_FUNC parameter must be function reference.");
    }

    if($exec_func and not ref($exec_func) eq 'CODE') {
	$self->throw("The -EXEC_FUNC parameter must be function reference.");

    } elsif($get_obj) {
	if( $save_a and not ref($save_a) eq 'ARRAY') {
	    # $save_a is only used when working with objects.
	    $self->throw("The -SAVE_ARRAY parameter must supply an array reference".
			 "when not using an -EXEC_FUNC parameter.",
			 "Supplied: $save_a");
	} elsif(not ($save_a or $exec_func)) {
	    $self->throw("No -EXEC_FUNC or -SAVE_ARRAY parameter was specified.");
	}

    } elsif(not( ref($seq_a) eq 'ARRAY' and ref($id_a) eq 'ARRAY' 
		 and ref($desc_a) eq 'ARRAY')) {
	# If we're not going to be returning objects, the $seq_a, $id_a, and $desc_a 
	# variables must all be array references.
	$self->throw("The -SEQS, -IDS, and -DESCS parameters must be array references.");
    }

    $MONITOR && printf STDERR "\nFasta sequence %s (100/dot, 5000/line).\n", $get_obj?'objects':'data';

    require Bio::Seq if $get_obj;

    ## Build the closure.
 
    return sub {
    ## $data should contain a complete sequence entry in one chunk. (record separator = "\n>").
	my ($data) = @_;
	return 1 unless $data =~ m/^(.+?)\n(.+)$/s;

	my ($id, $desc) = $self->_set_id_desc($1);
	my $seq = $2;
	
	# Cleaning up last seq which may have extra garbage.
	# Since we are splitting on "\n>" the last seq will not have a "\n>"
	# unless it is part of a catenation of files, hence the check for 
	# additional chars before the '>'.
	if(not $seq =~ /[\w\*]\n>$/s) {
	    my @lines = split("\n", $seq);
	    $seq = '';
	    foreach(@lines) {
		$seq .= $_ unless (m/\S \S/ or m/^[\W\s]*$/);
	    }
	}

#	return 1 if ($seq =~ /\S \S/s);
	
	## General editing of the sequence: remove whitespace and non-alphabetic chars.
	## Gaps characters are permitted. ('.' and '-').
	$seq =~ s/[^\w.-]//g;
	$seq =~ s/\s//g;

	return 1 if (!$seq);  # skip empty seqs
	
	$self->{'_seqCount'}++;

	## Should the sequence be filtered out?
	if(defined($filt_func) and &$filt_func(length($seq), $id, $desc)) {
	    $self->{'_seqCount'}--;
	    return 1;
	}
	
	## Special editing of the sequence: remove any ambiguous 
	## residues at begin or end of seq.
	if($edit_seq) {
	    $seq =~ s/^X+|X+$//g; 
	    $seq =~ s/^N+|N+$//g if $nucl; 
	    $seq =~ s/U/X/g if !$nucl;   # some peptide seqs have U's (why?)
	    # Check for sequences comprised only of ambiguous characters.
	    if(($nucl and $seq =~ /^N+$/) or
	       (!$nucl and $seq =~ /^X+$/)) {
		$self->warn("Sequence $id is 100% ambiguous");
		return 1;
	    }
	}	    
	
	## Construct new sequence objects constructed with the extracted data
	## and either execute a function or load an array with them,
	## -OR-
	## Execute a function with the raw data or load it into supplied arrays.
	if($get_obj) {
	    $seq = new Bio::Seq(-ID     =>$id,
				-SEQ    =>$seq,
				-DESC   =>$desc,
				-STRICT =>$strict,
				-TYPE   =>($type || undef),
				);
	    if($exec_func) {
		&$exec_func($seq);
		$seq->destroy;  # clean up. Could be memory problems otherwise.
	    } else {
		push @$save_a, $seq; 
	    }
	} else {
	    if($exec_func) {
		&$exec_func($id, $desc, $seq);
	    } else {
		push @$id_a, $id;
		push @$desc_a, $desc;
		push @$seq_a, $seq;
	    }
	}
	
	if($MONITOR) {
	    print STDERR ( $self->{'_seqCount'} % 100 ? '' : '.' );
	    print STDERR ( $self->{'_seqCount'} % 5000 ? '' : "\n" );
	}
	1;
    }
}


=head2 edit_id

 Usage     : $fasta_obj->edit_id()
 Purpose   : Set/Get a boolean indicator as to whether sequence IDs should be edited.
           : Used when parsing Fasta sequence files.
 Returns   : Boolean (true if the IDs are to be edited).
 Argument  : Boolean (optional)
 Throws    : n/a

See Also   : L<_set_id_desc>(), L<_get_parse_seq_func>()

=cut

#-------------
sub edit_id {
#-------------
    my $self = shift;
    if(@_) { $self->{'_edit_id'} = shift; }
    $self->{'_edit_id'};
}


=head2 edit_seqs

 Usage     : $fasta_obj->edit_seqs()
 Purpose   : Set/Get a boolean indicator as to whether sequences should be edited.
           : Used when parsing Fasta sequence files.
 Returns   : Boolean (true if the sequences are to be edited).
 Argument  : Boolean (optional)
 Throws    : n/a

See Also   : L<_get_parse_seq_func>()

=cut

#-------------
sub edit_seq {
#-------------
    my $self = shift;
    if(@_) { $self->{'_edit_seq'} = shift; }
    $self->{'_edit_seq'};
}



=head2 _set_id_desc

 Usage     : n/a. Internal method called by _get_parse_seq_func()
 Purpose   : Sets the _id and _desc data members, optionally editing the id.
           : Used when parsing Fasta sequence files.
 Returns   : 2-element list containing: ($id, $description)
 Argument  : String containing raw ID + description (leading '>' will be stripped)
 Throws    : n/a
 Comments  : Optionally edits the ID if the '_edit_id' field is true.
           : Descriptions are not altered.
           : ID Edits:
           :   1) Uppercases the ID.
           :   2) If the ID has any | characters the following is performed:
           :        a) Replace | characters with _ characters.
           :           (prevent regexp and shell trouble).
           :        b) Cleans up complex identifiers. 
           :           Some GenBank specifiers have multiple parts:
           :           >gi|2980872|gnl|PID|e1283615 homeobox protein SHOTb
           :           Only the first ID is saved as the official ID. 
           :           Extra ids will be included at the end of the 
           :           description between brackets:
           :           GI_2980872 homeobox protein SHOTb [ GNL PID e1283615 ]
           :
           : ID editing is somewhat experimental.

See Also   : L<_get_parse_seq_func>(), L<edit_id>()

=cut

#----------------
sub _set_id_desc {
#----------------
    my ($self, $data) = @_;
    my ($id, @desc) = split /\s+/, $data;
    $id =~ s/^>//;

    my $desc_tag = '';

    if($self->{'_edit_id'}) {
	$id = uc($id);  # Uppercase
	if($id =~ s/\|/\#/g) {
	    my @idParts = split( /\#/, $id );
	    if( scalar @idParts > 1) {
		$id = $idParts[0].'_'.$idParts[1];
	    }
	    if($idParts[2]) {
		$desc_tag = ' ['.join(' ',@idParts[2..$#idParts]).']';
	    }
	}
    }

    return ($id, join(' ',@desc).$desc_tag);
}


=head2 num_seqs

 Usage     : $fasta_obj->num_seqs()
 Purpose   : Get the number of sequences read by the Fasta object.
 Returns   : Integer 
 Argument  : n/a
 Throws    : n/a

=cut

#------------
sub num_seqs { my $self = shift;  $self->{'_seqCount'}; }
#------------




1;
__END__

#####################################################################################
#                                END OF CLASS                                       #
#####################################################################################

=head1 FOR DEVELOPERS ONLY

=head2 Data Members

Information about the various data members of this module is provided for those 
wishing to modify or understand the code. Two things to bear in mind: 

=over 4

=item 1 Do NOT rely on these in any code outside of this module. 

All data members are prefixed with an underscore to signify that they are private.
Always use accessor methods. If the accessor doesn't exist or is inadequate, 
create or modify an accessor (and let me know, too!). 

=item 2 This documentation may be incomplete and out of date.

It is easy for these data member descriptions to become obsolete as 
this module is still evolving. Always double check this info and search 
for members not described here.

=back

An instance of Bio::Tools::Fasta.pm is a blessed reference to a hash containing
all or some of the following fields:

 FIELD           VALUE
 --------------------------------------------------------------
 _seqCount       Number of sequences parsed.

 _edit_seq       Boolean. Should sequences be edited during parsing?

 _edit_id        Boolean. Should ids be edited during parsing?

 More data members will be added when code for Fasta report
 processing is incorporated.


 INHERITED DATA MEMBERS 

(See Bio::Tools::SeqAnal.pm for inherited data members.)

=cut


MODIFICATION NOTES:
-------------------
0.014, steve --- Wed Feb 17 02:22:26 1999
  * Fixed bug in num_seqs().

0.013, sac --- Thu Feb  4 03:45:25 1999:
  * _parse_seq_stream() calls get_newline() to autoconfigure the
   record searator for different platforms.

0.012, sac --- Mon Sep  7 13:20:48 1998:
  * Modified _get_parse_seq_func() to destroy all created Seq objects
     after calling exec_func if an exec_func supplied.
     (A similar thing is done in Bio::Tools::Blast::_get_parse_func().)

0.011, sac --- Sun Jun 14 23:23:43 1998:
  * Minor changes.
