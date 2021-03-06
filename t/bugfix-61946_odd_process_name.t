use warnings;
use Test::More;
use Data::Dumper;

BEGIN { 
  if( $^O eq 'cygwin' ) {
      plan skip_all => 'Test irrelevant on cygwin';
  }

  use_ok('Proc::ProcessTable'); 
}


$SIG{CHLD} = 'IGNORE';

my $pid = fork;
die "cannot fork" unless defined $pid;

if ( $pid == 0 ) {
  #child
  $0 = '(ib_fmr(mlx4_0))';
  sleep 10000;
} else {
  #main
  sleep 1;
  my $t = Proc::ProcessTable->new;
  my $cmnd_quoted = quotemeta('(ib_fmr(mlx4_0))');
  my ($p) = grep { $_->{pid} == $pid } @{ $t->table };
  like( $p->{cmndline}, qr/$cmnd_quoted/, "odd process commandline bugfix" );
  kill 9, $pid;
}
done_testing();

