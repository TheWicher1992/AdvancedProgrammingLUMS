reverse_list :: [Int] -> [Int]
reverse_list = \list ->
    case list of
        [] -> []
        x:xs -> reverse_list xs ++ [x]

find_min :: [Int] -> Int
find_min = \list -> 
    case list of
        [] -> error "List cannot be empty!"
        [x] -> x
        x:xs | x > find_min xs -> find_min xs
        x:_ -> x

remove_one :: [Int] -> Int -> [Int]
remove_one = \list -> \v -> 
    case list of 
        [] -> error "Element not found!"
        x:xs | v==x -> xs
        x:xs -> x:remove_one xs v

insert_sorted :: [Int] -> Int -> [Int]
insert_sorted = \list -> \v ->
    case list of 
        x:xs | v>x -> x:insert_sorted xs v
        _ -> v:list

selection_sort :: [Int] -> [Int]
selection_sort = \list ->
    case list of 
        [] -> []
        _ -> find_min list:selection_sort
                (remove_one list (find_min list))

insertion_sort :: [Int] -> [Int]
insertion_sort = \list ->
    case list of 
        [] -> []
        x:xs -> insert_sorted (insertion_sort xs) x

main = print (insertion_sort [8, 9, 3, 4, 7])
