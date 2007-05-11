#!perl

use strict;
use warnings;

use Test::More tests => 15;

BEGIN { use_ok("Data::StackedMap"); }

my $data = Data::StackedMap->new();
isa_ok($data, "Data::StackedMap");

is($data->size, 1);
ok(!$data->exists("foo"));

$data->push();
is($data->size, 2);
$data->pop();
is($data->size, 1);

$data->set("a" => 10);
is($data->exists("a"), -1);
is($data->get("a"), 10);

$data->set("a" => 20);
is($data->get("a"), 20);

$data->push();
is($data->exists("a"), -2);
$data->set("a" => 30);
is($data->get("a"), 30);
$data->pop();
is($data->get("a"), 20);

$data->delete("a");
is($data->exists("a"), 0);

$data->set("a" => 10);
$data->push();
$data->delete("a");
is($data->exists("a"), -2);
$data->pop();

eval {
    $data->pop();
};
like($@, qr/Can't pop single layer stack/);