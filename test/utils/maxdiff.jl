module TestMaxdiff
    using Calculus2
    using Base.Test

    @test isequal(
        Calculus2.maxdiff(5, 7),
        2
    )

    @test isequal(
        Calculus2.maxdiff([0, 0, 3, 3], [+1, -1, +1, -1]),
        4
    )
end
