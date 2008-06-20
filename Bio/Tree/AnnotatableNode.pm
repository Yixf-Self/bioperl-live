# BioPerl module for Bio::Tree::AnnotatableNode
#
# Cared for by Mira Han <mirhan@indiana.edu>
#
# Copyright Mira Han
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::Tree::AnnotatableNode - A Tree Node with support for annotation

=head1 SYNOPSIS

    use Bio::Tree::AnnotatableNode;
    my $nodeA = Bio::Tree::AnnotatableNode->new();
    my $nodeL = Bio::Tree::AnnotatableNode->new();
    my $nodeR = Bio::Tree::AnnotatableNode->new();

    my $node = Bio::Tree::AnnotatableNode->new();
    $node->add_Descendents($nodeL);
    $node->add_Descendents($nodeR);

    print "node is not a leaf \n" if( $node->is_leaf);

    # $node is-a Bio::AnnotatableI, hence:
    my $ann_coll = $node->annotation();
    # $ann_coll is-a Bio::AnnotationCollectionI, hence:
    my @all_anns = $ann_coll->get_Annotations();
    # do something with the annotation objects

=head1 DESCRIPTION

Makes a Tree Node with Annotations, suitable for building a Tree.  See
L<Bio::Tree::Node> for a full list of functionality.

=head1 FEEDBACK

=head2 Mailing Lists

User feedback is an integral part of the evolution of this and other
Bioperl modules. Send your comments and suggestions preferably to
the Bioperl mailing list.  Your participation is much appreciated.

  bioperl-l@bioperl.org                  - General discussion
  http://bioperl.org/wiki/Mailing_lists  - About the mailing lists

=head2 Reporting Bugs

Report bugs to the Bioperl bug tracking system to help us keep track
of the bugs and their resolution. Bug reports can be submitted via
the web:

  http://bugzilla.open-bio.org/

=head1 AUTHOR - Mira Han

Email mirhan@indiana.edu

=head1 APPENDIX

The rest of the documentation details each of the object methods.
Internal methods are usually preceded with a _

=cut


# Let the code begin...

package Bio::Tree::AnnotatableNode;
use strict;

use Bio::Annotation::Collection;
use base qw(Bio::Tree::Node Bio::AnnotatableI);

=head2 new

 Title   : new
 Usage   : my $obj = Bio::Tree::AnnotatableNode->new();
 Function: Builds a new Bio::Tree::AnnotatableNode object
 Returns : Bio::Tree::AnnotatableNode
 Args    : -left          => pointer to Left descendent (optional)
           -right         => pointer to Right descenent (optional)
	         -branch_length => branch length [integer] (optional)
           -bootstrap     => bootstrap value (string)
           -description   => description of node
           -id            => unique id for node

=cut

sub new {
  my ($class,@args) = @_;
  my $self = $class->SUPER::new(@args);
  $self->debug("new AnnotatableNode\n");
  return $self;
}

sub DESTROY {
    my ($self) = @_;
    # try to insure that everything is cleaned up
    $self->SUPER::DESTROY();
    if( defined $self->{'_desc'} &&
	ref($self->{'_desc'}) =~ /ARRAY/i ) {
	while( my ($nodeid,$node) = each %{ $self->{'_desc'} } ) {
	    $node->{'_ancestor'} = undef; # insure no circular references
	    $node->DESTROY();
	    $node = undef;
	}
	$self->{'_desc'} = {};
    }
}

sub to_string{
   my ($self) = @_;
   my @tags = $self->get_all_tags;
   my $tagstr = '';
   if( @tags ) {
#       $tagstr = '[' . join(":", "&&NHX", 
#			    map { "$_=" .join(',',
#					      $self->get_tag_values($_))}
#			    @tags ) . ']';
   }
   return sprintf("%s%s%s",
		  defined $self->id ? $self->id : '',
		  defined $self->branch_length ? ':' . 
		  $self->branch_length : ' ',
		  $tagstr);
}

=head1 Methods for implementing Bio::AnnotatableI

=cut

=head2 annotation

 Title   : annotation
 Usage   : $ann = $seq->annotation or 
           $seq->annotation($ann)
 Function: Gets or sets the annotation
 Returns : Bio::AnnotationCollectionI object
 Args    : None or Bio::AnnotationCollectionI object
See L<Bio::AnnotationCollectionI> and L<Bio::Annotation::Collection>
for more information

=cut

sub annotation 
{
  my ($self,$value) = @_;
  if( defined $value ) {
    $self->throw("object of class ".ref($value)." does not implement ".
        "Bio::AnnotationCollectionI. Too bad.")      unless $value->isa("Bio::AnnotationCollectionI");
    $self->{'_annotation'} = $value;
  } 
  elsif( ! defined $self->{'_annotation'}) 
  {
    $self->{'_annotation'} = Bio::Annotation::Collection->new();
  }
  return $self->{'_annotation'};
}

=head2 add_tag_value

 Title   : add_tag_value
 Usage   : $node->add_tag_value($tag,$value)
 Function: Adds a tag value to a node 
 Returns : number of values stored for this tag
 Args    : $tag   - tag name
           $value - value to store for the tag

=cut

sub add_tag_value 
{
  my ($self,$tag,$value) = @_;
  if( ! defined $tag || ! defined $value ) {
    $self->warn("cannot call add_tag_value with an undefined value");
  }
  my $ac = $self->annotation();
  my $sv = new Bio::Annotation::SimpleValue(-value => $value);
  $ac->add_Annotation($tag, $sv); 
  return scalar $ac->get_Annotations($tag);
}

=head2 remove_tag

 Title   : remove_tag
 Usage   : $node->remove_tag($tag)
 Function: Remove the tag and all values for this tag
 Returns : boolean representing success (0 if tag does not exist)
 Args    : $tag - tagname to remove


=cut

sub remove_tag 
{
  my ($self,$tag) = @_;
  my $ac = $self->annotation();
  if( @{$ac->get_Annotations($tag)} ) {
    $ac->remove_Annotations($tag);
    return 1;
  }
  return 0;
}

=head2 remove_all_tags

 Title   : remove_all_tags
 Usage   : $node->remove_all_tags()
 Function: Removes all tags 
 Returns : None
 Args    : None

=cut

sub remove_all_tags
{
  my ($self) = @_;
  my $ac = $self->annotation();
  $ac->remove_Annotations();
  return;
}

=head2 get_all_tags

 Title   : get_all_tags
 Usage   : my @tags = $node->get_all_tags()
 Function: Gets all the tag names for this Node
 Returns : Array of tagnames
 Args    : None

=cut

sub get_all_tags{
  my ($self) = @_;
  my $ac = $self->annotation();
  my @tags = sort $ac->get_all_annotation_keys(); 
  # how to restrict it to SimpleValues?
  return @tags;
}

=head2 get_tag_values

 Title   : get_tag_values
 Usage   : my @values = $node->get_tag_value($tag)
 Function: Gets the values for given tag ($tag)
 Returns : Array of values or empty list if tag does not exist
 Args    : $tag - tag name

=cut

sub get_tag_values{
  my ($self,$tag) = @_;
  my $ac = $self->annotation();
  my @values = map {$_->value()} $ac->get_Annotations($tag);
  return @values;
}

=head2 has_tag

 Title   : has_tag
 Usage   : $node->has_tag($tag)
 Function: Boolean test if tag exists in the Node
 Returns : Boolean
 Args    : $tag - tagname

=cut

sub has_tag {
  my ($self,$tag) = @_;
  my $ac = $self->annotation();
  return ( scalar $ac->get_Annotations($tag) > 0);
}

1;
