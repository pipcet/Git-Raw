#!perl

use Test::More;

use Git::Raw;
use Cwd qw(abs_path);

my $path = abs_path('t/test_repo');
my $repo = Git::Raw::Repository -> open($path);

my $config = $repo -> config;
my $name   = $config -> str('user.name');
my $email  = $config -> str('user.email');

my $time = time();
my $off  = 120;
my $me   = Git::Raw::Signature -> new($name, $email, $time, $off);

my $commit = $repo -> head;

isa_ok $commit, 'Git::Raw::Commit';

my $branch_name = 'some_branch';

my $branch = $repo -> branch($branch_name, $commit);

is $branch -> type, 'direct';
is $branch -> name, 'refs/heads/some_branch';

my $head = $branch -> target($repo);

isa_ok $head, 'Git::Raw::Commit';

is $head -> message, "second commit\n";

my $look = Git::Raw::Branch -> lookup($repo, $branch_name, 1);

is $look -> type, 'direct';
is $look -> name, 'refs/heads/some_branch';

my $branches = [ sort { $a -> name cmp $b -> name } @{$repo -> branches} ];

is $branches -> [0] -> type, 'direct';
is $branches -> [0] -> name, 'refs/heads/master';

is $branches -> [1] -> type, 'direct';
is $branches -> [1] -> name, 'refs/heads/some_branch';

if ($ENV{NETWORK_TESTING} or $ENV{RELEASE_TESTING}) {
	is $branches -> [2] -> type, 'direct';
	is $branches -> [2] -> name, 'refs/remotes/github/master';
}

done_testing;
