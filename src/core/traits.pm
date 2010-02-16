# XXX Signature is wrong really - will fix once we can parse other things.
# XXX Use .^ once we learn how to parse it.
our multi trait_mod:<is>(Mu $child, Mu $parent) {
    $child.add_parent($child, $parent);
}

our multi trait_mod:<is>(Mu $child, Role $r) {
    $child.add_parent($child, $r!select!pun);
}

our multi trait_mod:<of>(ContainerDeclarand $cont, Mu \$type) {
    given substr($cont.name, 0, 1) {
        when '@' { }
        when '%' { }
        when '&' { }
        default  { pir::setprop__vPSP($cont.container, 'type', $type) }
    }
}

our multi trait_mod:<does>(Mu $target, Mu $r) {
    $target.add_composable($target, $r);
}

our multi trait_mod:<does>(ContainerDeclarand $c, Role $r) {
    $c.container does $r;
}