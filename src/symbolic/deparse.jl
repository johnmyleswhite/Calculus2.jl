const op_precedence = [
    :+ => 1,
    :- => 1,
    :* => 2,
    :/ => 2,
    :^ => 3,
]

function deparse(
    ex::Expr,
    outer_precedence::Integer = 0,
)
    if ex.head != :call
        return "$ex"
    end
    op, args = ex.args[1], ex.args[2:end]
    precedence = get(op_precedence, op, 0)
    if precedence == 0
        arg_list = join([deparse(arg) for arg in args], ", ")
        return "$op($arg_list)"
    end
    if length(args) == 1
        arg = deparse(args[1])
        return "$op$arg"
    end
    # TODO: Change exponentiation to not include space
    result = join([deparse(arg, precedence) for arg in args], " $op ")
    if precedence <= outer_precedence
        return "($result)"
    end
    return result
end

function deparse(
    other::Any,
    outer_precedence::Integer = 0,
)
    return string(other)
end
