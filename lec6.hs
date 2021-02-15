import Data.List

-- data IntTree = Nil | Node IntTree IntTree Int
-- data DoubleTree = Nil | Node DoubleTree DoubleTree Double
data Tree a = Nil | Node (Tree a) (Tree a) a

-- height :: Tree Int -> Int
-- height :: Tree Double -> Int
-- height :: Tree a -> Int

mytree :: Tree Int
mytree = Node (Node (Node Nil Nil 5) Nil 6) (Node Nil Nil 8) 7

data WithLogType a = WithLog a String

height :: Tree a -> WithLogType Int
height = \t ->
    case t of
        Nil -> WithLog 0 "at leaf"
        Node l r _ ->
            let WithLog hl _ = height l
                WithLog hr _ = height r
            in case t of
                _ | hl > hr -> 
                     (height l) >>= (\hl -> 
                        WithLog (hl+1) "left is higher")
                _ -> 
                     (height r) >>= (\hr ->
                        WithLog (hr+1) "right is higher")

bind :: WithLogType a -> (a -> WithLogType b) -> WithLogType b
bind = \(WithLog x lx) -> \f ->
    let WithLog y ly = f x
    in WithLog y (lx ++ '\n':ly)

main = 
    let WithLog result log = height mytree
    in putStr log


-- -- -- For discussion
-- -- bind :: [] a -> (a -> [] b) -> [] b

-- -- data Maybe a = Nothing | Just a
-- main = print (bind (find even [1,2,3,4,5]) (\x -> Just (x*x)))

-- class Bindable m where
--     bind :: m a -> (a -> m b) -> m b

-- instance Bindable Maybe where
--     bind = \v -> \f ->
--         case v of 
--             Nothing -> Nothing
--             Just x -> f x
