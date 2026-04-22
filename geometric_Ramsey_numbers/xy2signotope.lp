#const sb=off.

#script (python)
import clingo

def check_orient(sx1, sy1, sx2, sy2, sx3, sy3):
    x1, y1 = sx1.number, sy1.number
    x2, y2 = sx2.number, sy2.number
    x3, y3 = sx3.number, sy3.number

    val = (x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)

    if val > 0:
        return clingo.Number(1)
    if val < 0:
        return clingo.Number(-1)
    raise AssertionError(f"Collinear points detected: ({x1},{y1}), ({x2},{y2}), ({x3},{y3})")
#end.

l(A,B,C,@check_orient(X1,Y1,X2,Y2,X3,Y3)) :-
    A<B, B<C, xy(A,X1,Y1), xy(B,X2,Y2), xy(C,X3,Y3).

#show xy/3.
