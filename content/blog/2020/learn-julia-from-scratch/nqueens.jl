# N queens puzzle solver
function nqueens(n)
    @assert n ≥ 1
    # queens' rank (row) for each file (column)
    # rank[file] = 0 means no queen is placed at the file
    ranks = zeros(Int, n)
    return solve(ranks, 1)
end

# recursive solver
function solve(ranks, file)
    n = length(ranks)
    nsols = 0  # the number of solutions
    for rank in 1:n
        # check ranks
        if any(rank == ranks[i] for i in 1:file-1)
            continue
        end
        # check diagonals
        if any(file-i == abs(rank-ranks[i]) for i in 1:file-1)
            continue
        end
        # put queen at (rank, file)
        ranks[file] = rank
        if file == n
            # found a solution
            nsols += 1
        else
            # go to the next file
            nsols += solve(ranks, file + 1)
        end
        ranks[file] = 0
    end
    return nsols
end
