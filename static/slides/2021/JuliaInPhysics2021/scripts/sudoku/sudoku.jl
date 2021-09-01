# Simple Sudoku solver
# --------------------

function solve(puzzle)
    next(i, j) = i < 9 ? (i + 1, j) : (1, j + 1)
    function solveit(sol, pos)
        i, j = pos
        if j > 9
            return true
        elseif sol[i,j] > 0
            return solveit(sol, next(i, j))
        end
        m, n = (i - 1) ÷ 3, (j - 1) ÷ 3
        for k in 1:9
            if all(sol[i,j] != k for i in 1:9) &&
               all(sol[i,j] != k for j in 1:9) &&
               all(sol[i,j] != k for j in 3n+1:3n+3,
                                     i in 3m+1:3m+3)
                sol[i,j] = k
                solveit(sol, next(i, j)) && return true
            end
        end
        sol[i,j] = 0
        return false
    end
    sol = copy(puzzle)
    return solveit(sol, (1, 1)) ? sol : nothing
end

function load(file)
    puzzle = zeros(Int, 9, 9)
    i = 1
    for line in eachline(file)
        line = strip(line)
        (isempty(line) || startswith(line, '#')) && continue
        for (j, m) in enumerate(eachmatch(r"[0-9]", line))
            puzzle[i,j] = parse(Int, m.match)
        end
        i += 1
    end
    return puzzle
end

puz = load(stdin)
sol = solve(puz)
if sol === nothing
    println("no solution")
else
    for i in 1:9
        println(join(sol[i,:], ' '))
    end
end