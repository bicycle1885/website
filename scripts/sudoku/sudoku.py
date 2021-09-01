# Simple Sudoku solver
# --------------------

def solve(puzzle):
    def next(i, j):
        if j < 8:
            return (i, j + 1)
        else:
            return (i + 1, 0)

    def solveit(sol, pos):
        i, j = pos
        if i > 8:
            return True
        elif sol[i][j] > 0:
            return solveit(sol, next(i, j))

        m, n = i // 3, j // 3
        for k in range(1, 10):
            ok = True
            for jj in range(9):
                if sol[i][jj] == k:
                    ok = False
                    break
            if not ok:
                continue
            for ii in range(9):
                if sol[ii][j] == k:
                    ok = False
                    break
            if not ok:
                continue
            for ii in range(3*m, 3*m+3):
                for jj in range(3*n, 3*n+3):
                    if sol[ii][jj] == k:
                        ok = False
                        break
                if not ok:
                    break
            if not ok:
                continue
            sol[i][j] = k
            if solveit(sol, next(i, j)):
                return True

        sol[i][j] = 0
        return False

    import copy
    sol = copy.deepcopy(puzzle)
    if solveit(sol, (0, 0)):
        return sol 
    else:
        return None

def load(file):
    import re
    puzzle = []
    for line in file:
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        row = []
        for m in re.findall(r'[0-9]', line):
            row.append(int(m))
        puzzle.append(row)
    return puzzle

import sys
puz = load(sys.stdin)
sol = solve(puz)
if not sol:
    print("no solution")
else:
    for i in range(9):
        print(' '.join(map(str, sol[i])))