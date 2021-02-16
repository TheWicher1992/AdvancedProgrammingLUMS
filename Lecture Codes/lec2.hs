merge :: [Int] -> [Int] -> [Int]
merge = \s1 -> \s2 ->
    case s1 of
        [] -> s2
        x:xs ->
            case s2 of
                y:ys | x>y -> y:merge s1 ys
                _ -> x:merge xs s2

split :: [Int] -> ([Int], [Int])
split = \list -> 
    case list of
        [] -> ([], [])
        x:xs -> 
            let (odds, evens) = split xs
            in (x:evens, odds)

smallerEq :: Int -> [Int] -> [Int]
smallerEq = \v -> \list ->
    case list of
        x:xs | x<=v -> x:smallerEq v xs
        _:xs -> smallerEq v xs
        _ -> []

greater :: Int -> [Int] -> [Int]
greater = \v -> \list ->
    case list of
        [] -> []
        x:xs | x>v -> x:greater v xs
        _:xs -> greater v xs

mergesort :: [Int] -> [Int]
mergesort = \list ->
    case list of
        [] -> []
        [x] -> [x]
        _ ->
            let (evens, odds) = split list
            in merge (mergesort evens) (mergesort odds)

qsort :: [Int] -> [Int]
qsort = \list ->
    case list of
        [] -> []
        x:xs -> 
            qsort (smallerEq x xs) ++ x:qsort (greater x xs)

main = print (qsort [4,4,1,8,9,2])