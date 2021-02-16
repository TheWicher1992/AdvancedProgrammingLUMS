doubleEvery :: [] Int -> [] Int
doubleEvery = \list ->
    case list of
        [] -> []
        x:xs -> x*2:doubleEvery xs

squareEvery :: [] Int -> [] Int
squareEvery = \list ->
    case list of
        [] -> []
        x:xs -> x*x:squareEvery xs

map :: (a -> a) -> [] a -> [] a
map :: (a -> b) -> [] a -> [] b
map = \fn -> \list ->
    case list of
        [] -> []
        x:xs -> fn x:map fn xs

filter :: (a -> Bool) -> [] a -> [] a
foldr :: (a -> b -> b) -> b -> [] a -> b



main = print (map even [1,2,3])

[1,2,3] ====> [False, True, False]


sumInt :: [] Int -> Int
sumInt = \list ->
    case list of
        [] -> 0
        x:xs -> x + sumInt xs

sumDouble :: [] Double -> Double
sumDouble = \list ->
    case list of
        [] -> []
        x:xs -> x + sumDouble xs

sumAny :: Num a => [] a -> a
sumAny = \list ->
    case list of
        [] -> 0
        x:xs -> x + sumAny xs

class Eq a where
    (==) :: a -> a -> Bool 

instance Equatable Int where
    eq = \x -> \y -> x == y

_elem :: Eq a => a -> [] a -> Bool
_elem = \v -> \list ->
    case list of
        [] -> False
        x:_ | x == v -> True
        _:xs -> _elem v xs

main = print (_elem "5" ["1","2","5"])