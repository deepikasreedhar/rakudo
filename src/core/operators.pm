our multi infix:<~~>(Mu $topic, Mu $matcher) {
    $matcher.ACCEPTS($topic)
}

our multi infix:<~~>(Mu $topic, Regex $matcher) {
    Q:PIR {
        $P0 = find_lex '$matcher'
        $P1 = find_lex '$topic'
        %r = $P0.'ACCEPTS'($P1)
        store_dynamic_lex '$/', %r
    };
}

class Substitution { ... }
our multi infix:<~~>(Mu $topic is rw, Substitution $matcher) {
    $matcher.ACCEPTS($topic)
}


our multi infix:<!~~>(Mu $topic, Mu $matcher) {
    $matcher.REJECTS($topic)
}

our multi prefix:<?>(Mu $a) {
    $a.Bool;
}

our multi prefix:<!>(Mu $a) {
    $a.Bool ?? False !! True;
}

our multi sub prefix:<->($a) {
    pir::neg__NN($a)
}

our multi sub infix:<+>($a, $b) {
    pir::add__NNN($a, $b)
}

our multi sub infix:<->($a, $b) {
    pir::sub__NNN($a, $b)
}

our multi sub infix:<*>($a, $b) {
    pir::mul__NNN($a, $b)
}

our multi sub infix:</>($a, $b) {
    pir::div__NNN($a, $b)
}

our multi sub infix:<%>($a, $b) {
    pir::mod__NNN($a, $b)
}

our multi sub infix:<**>($a, $b) {
    pir::pow__NNN($a, $b)
}

our multi sub infix:<&>(*@items) {
    Junction.new(@items, :all)
}

our multi sub infix:<|>(*@items) {
    Junction.new(@items, :any)
}

our multi sub infix:<^>(*@items) {
    Junction.new(@items, :one)
}

our sub all(*@items) {
    Junction.new(@items, :all);
}

our sub any(*@items) {
    Junction.new(@items, :any);
}

our sub one(*@items) {
    Junction.new(@items, :one);
}

our sub none(*@items) {
    Junction.new(@items, :none);
}

our multi prefix:<not>($x) { !$x }

our multi prefix:<so>($x) { ?$x }

our multi prefix:sym<+^>($x) {
    pir::bnot__PP($x)
}

our sub undefine(Mu \$x) {
    my $undefined;
    $x = $undefined;
}

our multi infix:<does>(Mu \$do-it-to-me, Role $r) {
    &infix:<does>($do-it-to-me, $r!select)
}

our multi infix:<does>(Mu \$do-it-to-me, ConcreteRole $r) {
    my $applicator = $r.^applier_for($do-it-to-me);
    $applicator.apply($do-it-to-me, [$r]);
    $do-it-to-me
}

our multi infix:<but>(Mu \$do-it-to-me, \$r) {
    $do-it-to-me.clone() does $r
}

our multi infix:<before>($a, $b) {
    ($a cmp $b) == -1;
}

our multi infix:<after>($a, $b) {
    ($a cmp $b) == +1;
}

our multi infix:<?|>($a, $b) {
    ?(?$a +| ?$b)
}

our multi infix:<?&>($a, $b) {
    ?(?$a +& ?$b)
}

our multi infix:<?^>($a, $b) {
    ?(?$a +^ ?$b)
}

our multi infix:<min>(*@args) {
    @args.min;
}

our multi infix:<max>(*@args) {
    @args.max;
}

our multi infix:«=>»($key, Mu $value) {
    Pair.new(key => $key, value => $value);
}

our multi infix:<~>($a, $b) {
    my $result = pir::new__Ps('Str');
    pir::assign__vPS($result, pir::concat__SSS(~$a, ~$b));
    $result
}

our sub circumfix:<{ }>(*@elements) {
    my %h = @elements;
    %h
}

our sub hash(*@list, *%hash) {
    my %h = (@list, %hash);
    %h
}

our multi infix:sym<//>(Mu $a, Mu $b) {
    $a.defined ?? $a !! $b
}

our multi infix:<==>($a, $b) {
    pir::iseq__INN(+$a, +$b) ?? True !! False
}

our multi infix:<!=>($a, $b) {
    $a !== $b
}

our multi infix:«<»($a, $b) {
    pir::islt__INN(+$a, +$b) ?? True !! False
}

our multi infix:«<=»($a, $b) {
    pir::isle__INN(+$a, +$b) ?? True !! False
}

our multi infix:«>»($a, $b) {
    pir::isgt__INN(+$a, +$b) ?? True !! False
}

our multi infix:«>=»($a, $b) {
    pir::isge__INN(+$a, +$b) ?? True !! False
}

our multi infix:<eq>($a, $b) {
    pir::iseq__ISS(~$a, ~$b) ?? True !! False
}

our multi infix:<ne>($a, $b) {
    $a !eq $b
}

our multi infix:<lt>($a, $b) {
    pir::islt__ISS(~$a, ~$b) ?? True !! False
}

our multi infix:<le>($a, $b) {
    pir::isle__ISS(~$a, ~$b) ?? True !! False
}

our multi infix:<gt>($a, $b) {
    pir::isgt__ISS(~$a, ~$b) ?? True !! False
}

our multi infix:<ge>($a, $b) {
    pir::isge__ISS(~$a, ~$b) ?? True !! False
}

# XXX Lazy version would be nice in the future too.
our multi infix:<xx>(Mu \$item, $n) {
    my @result = ();
    for 1..$n {
        @result.push($item);
    }
    @result
}

our multi prefix:<|>(@a) { @a.Capture }
our multi prefix:<|>(%h) { %h.Capture }
our multi prefix:<|>(Capture $c) { $c }
our multi prefix:<|>(Mu $fail) { die 'Cannot use prefix:<|> with a ' ~ $fail.WHAT; }

our multi infix:<:=>(Mu $a, Mu $b) {
    die ":= binding of variables not yet implemented";
}

our multi infix:<:=>(Signature $s, Parcel \$p) {
    $s!BIND($p.Capture());
}

our multi infix:<:=>(Signature $s, Mu \$val) {
    $s!BIND(Capture.new($val));
}

# XXX Wants to be a macro when we have them.
our sub WHAT(\$x) {
    $x.WHAT
}

our multi sub item(*@values) {
    @values.Seq
}
our multi sub item(@values) {
    @values.Seq
}
our multi sub item($item) {
    $item
}

class Whatever { ... }

# the magic one that handles stuff like
# 'a' ... 'z' and 'z' ... 'a'
our multi sub infix:<...>($lhs, $rhs) {
    if $rhs ~~ Whatever {
        my $i = $lhs;
        return gather {
            loop {
                my $j = $i++;
                take $j;
            }
        }
    }

    gather {
        take $lhs;
        if ($lhs cmp $rhs) == 1 {
            my $x = $lhs;
            # since my $a = 'a'; $a-- gives
            # "Decrement out of range" we can't easily
            # decrement over our target, which is why the
            # case of going backwards is slighly more complicated
            # than going forward
            while (--$x cmp $rhs) == 1 {
                # need to make a fresh copy here because of RT #62178
                my $y = $x;
                take $y;
            }
            take $x if ($x cmp $rhs) == 0;
        } elsif ($lhs cmp $rhs) == -1 {
            my $x = $lhs;
            while (++$x cmp $rhs) <= 0 {
                my $y = $x;
                take $y;
            }
        }
    }
}

# our multi sub infix:<...>($lhs, Code $rhs) {
#     if $rhs.count != 1 {
#         die "Series operator currently cannot handle blocks with count != 1";
#     }
#
#     my $i = $lhs;
#     gather {
#         my $j = $i;
#         take $j;
#         my $last = $i;
#         loop {
#             $i = $rhs.($last);
#             my $j = $i;
#             take $j;
#             $last = $i;
#         }
#     }
# }
#
# our multi sub infix:<...>(@lhs, Whatever) {
#     given @lhs.elems {
#         when 2 {
#             @lhs[0] ... { $_ + (@lhs[1] - @lhs[0]) };
#         }
#         when 3 {
#             if @lhs[1] - @lhs[0] == @lhs[2] - @lhs[1] {
#                 @lhs[0] ... { $_ + (@lhs[1] - @lhs[0]) };
#             } elsif @lhs[1] / @lhs[0] == @lhs[2] / @lhs[1] {
#                 @lhs[0] ... { $_ * (@lhs[1] / @lhs[0]) };
#             } else {
#                 fail "Unable to figure out pattern of series";
#             }
#         }
#         default { fail "Unable to figure out pattern of series"; }
#     }
# }

our multi sub infix:<...>(Code $lhs, $rhs) {
    my $limit;
    $limit = $rhs if !($rhs ~~ Whatever);
    my $last;
    gather {
        loop {
            my $i = $lhs.();
            my $j = $i;
            last if $limit.defined && $last.defined && !($j eqv $limit)
                 && ($last before $limit before $j || $j before $limit before $last);
            take $j;
            last if $limit.defined && $j eqv $limit;
            $last = $j;
        }
    }
}

our multi sub infix:<...>(@lhs is copy, $rhs) {
    my $limit;
    $limit = $rhs if !($rhs ~~ Whatever);

    my $next;
    if @lhs[@lhs.elems - 1] ~~ Code {
        $next = @lhs.pop;
    } else {
        given @lhs.elems {
            when 1 {
                if @lhs[0] cmp $rhs == 1 {
                    $next = { .prec };
                } else {
                    $next = { .succ };
                }
            }
            when 2 {
                $next = { $_ + (@lhs[1] - @lhs[0]) };
            }
            when 3 {
                if @lhs[1] - @lhs[0] == @lhs[2] - @lhs[1] {
                    $next = { $_ + (@lhs[1] - @lhs[0]) };
                } elsif @lhs[1] / @lhs[0] == @lhs[2] / @lhs[1] {
                    $next = { $_ * (@lhs[1] / @lhs[0]) };
                } else {
                    fail "Unable to figure out pattern of series";
                }
            }
            default { fail "Unable to figure out pattern of series"; }
        }
    }

    my $arity = any( $next.signature.params>>.slurpy ) ?? Inf !! $next.count;

    gather {
        my @args;
        my $j;
        my $top = $arity min @lhs.elems;
        for 0..^$top -> $i {
            $j = @lhs[$i];
            take $j;
            @args.push($j);
        }

        if !$limit.defined || $limit cmp $j != 0 {
            loop {
                my $i = $next.(|@args);
                my $j = $i;

                my $cur_cmp = 1;
                if $limit.defined {
                    $cur_cmp = $limit cmp $j;
                    last if (@args[@args.elems - 1] cmp $limit) == $cur_cmp;
                }
                take $j;
                last if $cur_cmp == 0;

                @args.push($j);
                while @args.elems > $arity {
                    @args.shift;
                }
            }
        }
    }
}

our multi sub infix:<eqv>(Mu $a, Mu $b) {
    $a.WHAT === $b.WHAT && $a === $b;
}

our multi sub infix:<eqv>(@a, @b) {
    unless @a.WHAT === @b.WHAT && @a.elems == @b.elems {
        return Bool::False
    }
    for @a.keys -> $i {
        unless @a[$i] eqv @b[$i] {
            return Bool::False;
        }
    }
    Bool::True
}

our multi sub infix:<eqv>(Pair $a, Pair $b) {
    $a.key eqv $b.key && $a.value eqv $b.value;
}

our multi sub infix:<eqv>(Capture $a, Capture $b) {
    @($a) eqv @($b) && %($a) eqv %($b)
}

class EnumMap { ... }
our multi sub infix:<eqv>(EnumMap $a, EnumMap $b) {
    if +$a != +$b { return Bool::False }
    for $a.kv -> $k, $v {
        unless $b.exists($k) && $b{$k} eqv $v {
            return Bool::False;
        }
    }
    Bool::True;
}

our multi sub infix:<Z>(Iterable $a-iterable, Iterable $b-iterable) {
    my $ai = $a-iterable.iterator;
    my $bi = $b-iterable.iterator;
    gather loop {
        my $a = $ai.get;
        my $b = $bi.get;
        last if ($a ~~ EMPTY) || ($b ~~ EMPTY);
        take $a;
        take $b;
    }
}

our multi sub infix:<Z>($a, $b) { &infix:<Z>($a.list, $b.list) }

our multi sub infix:<X>(Iterable $a-iterable, Iterable $b-iterable) {
    my $ai = $a-iterable.iterator;
    my @b = $b-iterable.Seq;
    gather loop {
        my $a = $ai.get;
        last if ($a ~~ EMPTY);
        for @b -> $b {
            take ($a, $b);
        }
    }
}

our multi sub infix:<X>($a, $b) { &infix:<X>($a.list, $b.list) }

# Eliminate use of this one, but keep the pir around for
# the moment, as it may come in handy elsewhere.
#
# multi sub infix_prefix_meta_operator:<!>($a, $b, $c) {
#     !(pir::get_hll_global__CS($a)($b, $c));
# }

# CHEAT: These should be automatically generated by the grammar,
# I think.  But this is a quick fix to get some basic functionality
# working.

multi sub infix:<+>(Whatever, $rhs) {
    -> $a { $a + $rhs; };
}

multi sub infix:<+>($lhs, Whatever) {
    -> $a { $lhs + $a; };
}

multi sub infix:<+>(Whatever, Whatever) {
    -> $a, $b { $a + $b; };
}

multi sub infix:<->(Whatever, $rhs) {
    -> $a { $a - $rhs; };
}
