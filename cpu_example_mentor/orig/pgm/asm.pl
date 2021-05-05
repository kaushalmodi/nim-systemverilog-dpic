#!/usr/bin/perl -n

# This is an assembler script to generate memory images for the risc CPU

BEGIN {
    %opcode = (
	       HLT => 0xE0000000,
	       SKZ => 0x10000000,
	       ADD => 0x20000000,
	       SUB => 0x30000000,
	       XOR => 0x40000000,
	       LDA => 0x50000000,
	       STA => 0x60000000,
	       JMP => 0x70000000,
	       JSR => 0x80000000,
	       JMI => 0x90000000,
	       LDI => 0xA0000000,
	       STI => 0xB0000000,
	       );
    $address = 0;
    $i = 0;
}
$program[$i++] = $_;
chomp;
s#//.*##; # remove // comment
next unless /\S/; #skip blank lines
s/^\s*//; # remove leading whitespace
if (/(\w+)\s*=(.+)/) { # label = expr
    $symbol{$1} = eval ($2);
    next;
}
if (/^@(\d[0-9a-fxA-FX]*)/) { # @address
    $address = $1;
    $_ = $';     # remainder of string
    $address = oct($address) if $address =~ /^0/;
}
if (/(\w+):/) { # label:
    $symbol{$1} = $address;
    $_ = $';     # remainder of string
}
$address++ if /\S/; #skip blank lines

END {
    $address = 0;
    $maxi = $i;
    $i = 0;
    while($i<$maxi) {
	$word = '';
	$_ = $program[$i];
	chomp;
	s#//.*##; # remove // comment
	s/^\s*//; # remove leading whitespace
	next unless /\S/; #skip blank lines
	if (/(\w+)\s*=(.+)/) { # label = expr
	    next;
	}
	if (/^@(\d[0-9a-fA-FxX]*)\s*/) { # @address
	    $address = $1;
	    $_ = $';     # remainder of string
	    $address = eval($address) if $address =~ /^0/;
	    printf "\@%x ",$address;
	}
	if (/(\w+):\s*/) { # label:
	    $_ = $';     # remainder of string
	}
	next unless /\S/; #skip blank lines
	@token = split(' ',$_,2);
	if (defined $opcode{$token[0]}) {
	    $word = $opcode{$token[0]};
	    shift @token;
	}
	$token[0] = join (' ',@token);
	$symbol{PC} = $address;
	while (($key,$value) = each %symbol) {
            $token[0] =~ s/\b$key\b/$value/;
	}
	$word += eval($token[0]);
    } continue {
	if ($word ne '') {
	    printf("%-8x // %-12x %s",$word,$address++,$program[$i++]);
	} else {
	    printf("%8s // %s",$word,$program[$i++]);
	}
    }
}




