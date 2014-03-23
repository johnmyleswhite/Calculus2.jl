fatalerrors = length(ARGS) > 0 && ARGS[1] == "-f"
anyerrors = false

my_tests = [
    "utils/maxdiff.jl",
    "automatic/dualnumbers.jl",
    "symbolic/symbolic.jl",
    "symbolic/deparse.jl",
    "api/grad.jl",
    "api/hess.jl",
    "api/checker.jl",
    "api/integrate.jl",
]

println("Running tests:")

for my_test in my_tests
    try
        include(my_test)
        println("\t\033[1m\033[32mPASSED\033[0m: $(my_test)")
    catch
        anyerrors = true
        println("\t\033[1m\033[31mFAILED\033[0m: $(my_test)")
        if fatalerrors
            rethrow()
        end
    end
end

if anyerrors
    throw("Tests failed")
end
