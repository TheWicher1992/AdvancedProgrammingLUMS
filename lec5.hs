-- class Comparable a where
--     lte :: a -> a -> Bool
--     gt :: a -> a -> Bool

-- qsort :: [] Int -> [] Int
-- -- below is the more precise version
-- qsort :: Ord a => [] a -> [] a
-- qsort = \list ->
--     case list of
--         [] -> []
--         x:xs -> 
--             qsort (filter (<=x) xs) 
--                 ++ x:qsort (filter (>x) xs)

-- list :: [] Int
-- list = [5,4,7,3,2,9]

-- instance Comparable Int where
--     gt = (>)
--     lte = (<=)

-- main = print (qsort list)

-- elem :: Eq a => a -> [] a -> Bool

-- Eq (==), Num (+ -), Ord (< <=...)

-- data ComplexType = 
--     ComplexVal Double Double | RealVal Double | Iota

-- absolute :: ComplexType -> Double
-- absolute = \x ->
--     case x of
--         ComplexVal real imag -> sqrt (real*real + imag*imag)
--         RealVal real -> absolute (ComplexVal real 0)
--         Iota -> absolute (ComplexVal 0 1)

-- main = print (absolute Iota)

data IntTree = Nil | Node IntTree IntTree Int
mytree :: IntTree
mytree = Node (Node (Node Nil Nil 5) Nil 6) (Node Nil Nil 8) 7

height :: IntTree -> Int
height = \t ->
    case t of
        Nil -> 0
        Node l r _ | height l > height r -> height l + 1
        Node _ r _ -> height r + 1

main = print (height mytree)