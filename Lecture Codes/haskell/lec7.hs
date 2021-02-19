import Control.Monad

data Tree a = Nil | Node (Tree a) (Tree a) a

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
                    height l >>= \hl -> 
                    WithLog (hl+1) "left is higher"
                _ -> 
                    height r >>= \hr ->
                    WithLog (hr+1) "right is higher"

instance Functor WithLogType where
    fmap = liftM
instance Applicative WithLogType where
    pure = \x -> WithLog x ""
    (<*>) = ap
instance Monad WithLogType where
    (>>=) = \(WithLog x lx) -> \f ->
        let WithLog y ly = f x
        in WithLog y (lx ++ '\n':ly)

main = let WithLog result log = height mytree in putStr log

-- instance Monad Maybe where
--     (>>=) = \x -> \f ->
--         case x of
--             Nothing -> Nothing
--             Just y -> f y
-- main = 
--     let WithLog _ log = height mytree
--     in putStr log

-- import Data.List

-- main =
--     print (
--         find even [1,3,5] >>= \x -> 
--         Just (x*10) >>= \y ->
--         find (==y*10) [100,200,300,400,500] >>= \z ->
--         Just (z*z)
--     )

-- main :: IO ()
-- main = 
--     putStrLn "Enter your name: " >>= \_ ->
--     getLine >>= \ln ->
--     putStrLn ("Hello " ++ ln)

