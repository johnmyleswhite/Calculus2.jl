macro hessexpr(ex_f, xs)
    return esc(hessexpr(ex_f, xs))
end
