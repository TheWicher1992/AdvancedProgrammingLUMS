score :: String -> String -> Int
score = \dna1 -> \dna2 ->
    case dna1 of
        "" -> case dna2 of
                "" -> 0
                y:ys -> 1 + score "" ys
        x:xs -> case dna2 of
                    "" -> 1 + score xs ""    
                    y:ys | y == x -> max (max (1 + score xs dna2) (1 + score dna1 ys)) (4 + score xs ys)
                    y:ys -> max (max (1 + score xs dna2) (1 + score dna1 ys)) (3 + score xs ys)
                    
main = print (score "ACG" "CCTGAT")