-- foldr :: (Int -> Int -> Int) -> Int -> [Int] -> Int
-- foldr = \fn -> \id -> \list ->
--     case list of 
--         [] -> id
--         x:xs -> fn x (foldr fn id xs)

-- filter :: (Int -> Bool) -> [Int] -> [Int]
-- filter = \pred -> \list ->
--     case list of
--         [] -> []
--         x:xs | pred x -> x:filter pred xs
--         _:xs -> filter pred xs

qsort :: [Int] -> [Int]
qsort = \list ->
    case list of
        [] -> []
        x:xs -> qsort (filter (<=x) xs) ++ x:qsort (filter (>x) xs)

main = print (qsort [1,6,3,5,9,7,6,4,7])