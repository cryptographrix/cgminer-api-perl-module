#!/usr/bin/perl
# = CGminer.pm
#
# == Description
#
# Perl module to interface with the cgminer api
#
# == License
#
# "THE BEER-WARE LICENSE" (Revision 42-mrenz):
#   Michael Renz <cryptographrix@gmail.com> wrote this file. As long as you
#   retain this notice you can do whatever you want with this stuff. If we
#   meet some day, and you think this stuff is worth it, you can buy me a beer.
#
use strict;
use warnings;

package CGminer;

use JSON;
use IO::Socket::INET;
$| = 1;

# == Important variables
#
# === $cgminer_server
# defaults to 127.0.0.1 but can be overriden in $main::cgminer_server
# $cgminer_port - defaults to 4028 but can be overridden in $main::cgminer_port
#
my $cgminer_server	= $main::cgminer_server  || "127.0.0.1";
my $cgminer_port	= $main::cgminer_port    || "4028";

# == Sub: cgminer_send_commands
#
# === Description
#
# This is the sub that connects with the CGminer socket.
#
# It is dumb and is called like:
#   cgminer_send_commands($command,$parameter);
#
# It returns the exact response from the server.
sub cgminer_send_commands {
  # Takes command, parameter
  my $cgminer_command->{'command'}   = $_[0];
  $cgminer_command->{'parameter'} = $_[1] || undef;

  my $cgminer_socket = IO::Socket::INET->new( Proto    =>"tcp",
                                              PeerPort =>$cgminer_port,
                                              PeerAddr =>$cgminer_server,
                                              Timeout => 1, Type => SOCK_STREAM )
    or die "Can't make TCP connection: $@";

  my $response;

  my $command_encoded = encode_json $cgminer_command;
  $cgminer_socket->send($command_encoded."\n");
  $response = <$cgminer_socket>;

  $response =~ s/false/"false"/g;
  $response =~ s/true/"true"/g;
  $response =~ s/%/ percentage/g;
  $response =~ s/ /_/g;
  $response =~ tr/A-Z/a-z/;

  return $response;
}

# == Sub: cgm_spc
#
# === Description
#
# This is the sub that wraps cgminer_send_commands and converts
#   the server response to a perl data structure.
sub cgm_spc {
  return decode_json cgminer_send_commands($_[0],$_[1] || undef);
}

sub version {
  return cgm_spc('version') ;
}

sub config {
  return cgm_spc('config') ;
}

sub summary {
  return cgm_spc('summary') ;
}

# == Sub: pools
#
# === Description
#
# This will provide a list of pools in response->{'POOLS'}
sub pools {
  return cgm_spc('pools') ;
}

sub devs {
  return cgm_spc('devs') ;
}

sub pga {
  return cgm_spc('pga',$_[0]) ;
}

sub pgacount {
  return cgm_spc('pgacount') ;
}

sub switchpool {
  return cgm_spc('switchpool',$_[0]) ;
}

sub enablepool {
  return cgm_spc('enablepool',$_[0]) ;
}

# == Sub: addpool
#
# === Description
#
# Takes URL, USER, PASSWORD as such:
#   addpool($url, $username, $password);
#
# Will use '123' as the default password if none is specified.
#
sub addpool {
  return cgm_spc('addpool',$_[0].",".$_[1].",".$_[2] || '123') ;
}

# == Sub: poolpriority
#
# === Description
#
# Takes a list of pool IDs and prioritizes them as such:
#   poolpriority($pool_one,$pool_two,$pool_three);
#
sub poolpriority {
  return cgm_spc('poolpriority', join(",",@_) ) ;
}

# == Sub: poolquota
#
# === Description
#
# Takes pool ID, quota value as such:
#   poolquota($pool_id, $pool_quota);
#
sub poolquota {
  return cgm_spc('poolquota', $_[0].",".$_[1]) ;
}

# == Sub: disablepool
#
# === Description
#
# Disables the pool whose ID you specify as such:
#   disablepool($pool_id);
#
sub disablepool {
  return cgm_spc('disablepool',$_[0]) ;
}

# == Sub: removepool
#
# === Description
#
# Removes the pool whose ID you specify as such:
#   removepool($pool_id);
#
sub removepool {
  return cgm_spc('removepool',$_[0]) ;
}

# == Sub: save
#
# === Description
#
# Saves the cgminer config to filename as such:
#   save($filename);
#
# Will save to "/root/.cgminer/cgminer.conf" if $filename is not specified.
sub save {
  return cgm_spc('save',$_[0] || "/root/.cgminer/cgminer.conf") ;
}

sub quit {
  return cgm_spc('quit') ;
}

sub notify {
  return cgm_spc('notify') ;
}

sub privileged {
  return cgm_spc('privileged') ;
}

sub pgaenable {
  return cgm_spc('pgaenable',$_[0]) ;
}

sub pgadisable {
  return cgm_spc('pgadisable',$_[0]) ;
}

sub pgaidentify {
  return cgm_spc('pgaidentify',$_[0]) ;
}

sub devdetails {
  return cgm_spc('devdetails') ;
}

sub restart {
  return cgm_spc('restart') ;
}

sub stats {
  return cgm_spc('stats') ;
}

sub check {
  return cgm_spc('check',$_[0]) ;
}

sub failover_only {
  return cgm_spc('failover-only',$_[0]) ;
}

sub coin {
  return cgm_spc('coin') ;
}

sub debug {
  return cgm_spc('debug',$_[0]) ;
}

sub setconfig {
  return cgm_spc('setconfig',$_[0].",".$_[1]) ;
}

sub usbstats {
  return cgm_spc('usbstats') ;
}

sub pgaset {
  return cgm_spc('pgaset',$_[0]) ;
}

sub zero {
  return cgm_spc('zero',$_[0]) ;
}

sub hotplug {
  return cgm_spc('hotplug',$_[0]) ;
}

sub asc {
  return cgm_spc('asc',$_[0]) ;
}

sub ascenable {
  return cgm_spc('ascenable',$_[0]) ;
}

sub ascdisable {
  return cgm_spc('ascdisable',$_[0]) ;
}

sub ascidentify {
  return cgm_spc('ascidentify',$_[0]) ;
}

sub asccount {
  return cgm_spc('asccount') ;
}

sub ascset {
  return cgm_spc('ascset',$_[0]) ;
}

sub lockstats {
  return cgm_spc('lockstats') ;
}






1;
