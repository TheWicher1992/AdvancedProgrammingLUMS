-- CS 300 Exam 1 on 21 Feb 2021 from 11am to 11pm

-- Before proceeding, press Alt-Z in Visual Studio Code so lines are wrapped

-- HONOR CODE:  I have taken the exam completely alone.  I have not consulted with any other person regarding the exam or any material from the course for the duration of the exam.  Except the six resources listed below, I have not consulted any other resource including searching the internet, accessing shared documents, or accessing any prior code I had.  I have reported any violation of the honor code that I knew and will report any that I may become aware of.  I understand that academic misconduct can result in disciplinary action.  

-- 

-- Write your full name and roll number to accept the honor code. (REQUIRED)
-- 22100104 Muhammad Sameer Nadeem

-- INSTRUCTIONS

-- * A textual description is REQUIRED with each part about how you solved it.
-- * You may only email the instructor about the exam (junaid.siddiqui@lums.edu.pk).  TAs will not be available.
-- * You can make any number of helper functions to solve your problem.  Most parts come with detailed hints and suggested helper functions but you are not required to follow them.  However, the provided main functions must work without any changes.
-- * You can work on the exam till Saturday 20 Feb 11 pm.  Submit on LMS.  Remember that internet outage is not a valid reason for extension since the prescribed setup works completely offline.
-- * The following six resources are allowed during the exam:
--      * Haskell Programming from first principles (http://haskellbook.com/)
--      * Learn You a Haskell for Great Good! (http://learnyouahaskell.com/chapters)
--      * Happy Learn Haskell Tutorial (http://www.happylearnhaskelltutorial.com/contents.html)
--      * Haskell (https://en.wikibooks.org/wiki/Haskell)
--      * Hoogle (https://hoogle.haskell.org/)
--      * The eight lecture summary emails sent from the instructor

import Data.List
import Data.Char

-- High level description

-- A common type of text alignment in print media is "justification," where the spaces between words, are stretched or compressed to align both the left and right ends of each line of text.  I​n this problem we’ll be implementing a text justification function for a monospaced terminal, i.e., fixed width font where every letter has the same width.  The alignment is achieved by inserting blanks and hyphenating the words.  For example, given this excerpt from George Orwell's famous novel 1984:

text :: String
text = "He who controls the past controls the future. He who controls the present controls the past."

-- We want to be able to align it like this to a specific width, say 15 columns:

-- He who controls
-- the  past cont‐ 
-- rols  the futu‐ 
-- re.  He who co‐ 
-- ntrols the pre‐ 
-- sent   controls 
-- the past.

-- We will implement this in three parts.


-- Part 1: Text fitting (8 points)

-- In this part, we want to fit the text within given width without justification or hyphenation.  The fitText function takes the column width, a list of words, and returns a list of lines where each line is a list of words.  See the main function and expected output below.  You may assume that no single word is longer than the given line length.  

-- Rest of the description below contains HINTS and you may choose not to follow it.
-- The test main uses the functions 'words' which splits a string into words, 'unwords' which joins words with spaces to form a single lines, and 'unlines' which joins lines with newline characters to form a paragraph.  If needed, you may use these functions in your code and remember that a 'length' function exists which can give you the length of any string.
-- Break the problem into two parts.  First, write the fitLine function that breaks a given list of words into two parts where the first part will fit into the given length, and everything else is in the second part.  You can use (length (unwords x)) to find the length occupied by a list of words stored in 'x'.  Remember the recursive thought process while writing this function.  Second, write the fitText function as a recursive function where you assume that the recursive function can correctly form the paragraph if only you can split out the first line correctly.  Both functions end up to be less than five lines of code.

fitLine :: Int -> [] String -> ([] String, [] String) -- Suggested
fitLine = \cols -> \list ->
    case list of
        [] -> ([],[])
        [x] | (length x) > cols -> ([], [x])
        [x] -> ([x], [])
        x:xs | (length x) <= cols -> let (p1, p2) = fitLine (cols - (length x) - 1) xs 
                                        in (x:p1, p2)
        x:xs -> ([],x:xs)


--main = print (fitLine 30 (words text) 0)

fitText :: Int -> [] String -> [] ([] String) -- Required
fitText = \cols -> \list -> 
    case list of
        [] -> []
        x:xs -> let (p1, p2) = fitLine cols list
                in let res = fitText cols p2 in
                [p1] ++ res

--main = putStr (unlines (map unwords (fitText 30 (words text))))

-- IMPORTANT: Type here a detailed description of your part 1 solution
-- fitLine function takes in 3 arguments 1:total cols, 2:list of words, 3:cols_counted
-- This function adds word to an array until the case where adding any more word will exceed the total cols
-- this function returns a tuple which contains a line with same or smaller columns then total cols and an another array
--  with the rest of the words.
-- the fitText was relatively easier after making the helper function. I thought to solve a mini problem and the pass the  -- rest of the problem to the same function as a recursive call. I use fitline to get the first line and then pass the rest 
-- to fitText which automatically then calls the fitLine again
--main = putStr (unlines (map unwords (fitText 30 (words text))))

-- Expected Output:

-- He who controls the past
-- controls the future. He who
-- controls the present controls
-- the past.


-- Part 2: Hyphenation (7 points)

-- In this part, we will add support for hyphenation, that will allow us to fit a bit more text in each line.  Our hyphenation dictionary is given as a list of tuples where the first member is a word which is allowed to be hyphenated and the second member of the tuple is a list of hyphenation points.  See expected output below.

-- Rest of the description below contains HINTS and you may choose not to follow it.
-- Start by copying the code of fitText in fitHyphenatedText accomodating for the extra argument.  Change the call to fitLine to the findHyphenatedLine function.  The fitHyphenatedLine function can use the fitLine function to find an initial split and then try hyphenating the first token not included in the line (if any) using the hyphenateWord function which should be passed the remaining space in the line.  Test your code till this point by making hyphenateWord always return hardcoded 'Just ("cont-", "rols")'.
-- Now you can write hyphenateWord which has to do a few things: 1) separate any punctuation (you may use 'span isAlpha wordsArray' that will split an array into a tuple of two arrays with the word in the first array and punctuation in the second, or you may write your own code). 2) Use the 'find' function (or your own code) to lookup if the word exists in the hyphenation dictionary. The 'find' function takes a predicate function and returns the first matching element inside 'Just', or 'Nothing' if no element matches.  3) Use findHyphenationPoint function (can be hardcoded for testing) to find the correct word split (e.g., 'cont' and 'rols').  4) Add a '-' to the first part and add back any punctuation removed earlier to the second part. 
-- Note that hyphenateWord has to connect find and findHyphenationPoint that both return Maybe and it has to itself return a Maybe.  If you understand the bind operator (>>=), using it will reduce your code for this function to a few lines.
-- Finally write findHyphenationPoint that has to find the largest part until a valid hyphenation point that can fit in the allowed length.  Find a smaller problem for the recursive call e.g. by removing a hyphenation point.  Choose among the removed hyphenation point and the best one returned from the recursive call.  The 'concat' function may be used to concatenate an array of strings together in to a single string.  Remember to return 'Nothing' if no point can fit in the allowed space.

-- fitLine :: Int -> [] String -> Int -> ([] String, [] String) -- Suggested

-- find bool

findFrom :: String -> [(String, [] String)] -> Maybe (String, [] String)
findFrom = \key -> \dict ->
    case dict of
        [] -> Nothing
        (k,v):xs | k == key -> Just (k,v)
        _:xs -> findFrom key xs



findHyphenationPoint :: [] String -> Int -> Maybe (String, String) -- Suggested
findHyphenationPoint = \dictv -> \colsr ->
    case dictv of
        x:xs | length x < colsr -> let res = findHyphenationPoint xs (colsr - length x) in
                                    case res of
                                        Just (a, b) -> Just (x++a, b)
                                        Nothing -> Just (x,concat xs) 
        x:xs -> Nothing

-- separate punctuations
-- use find to lookup word in dictionary 
-- find word split
-- add - to the first part

hyphenateWord :: [(String, [] String)] -> Int -> String -> Maybe (String, String) -- Suggested
hyphenateWord = \dict -> \cols -> \w -> 
    let (wordwop, puncs) = span isAlpha w
    in let fromDict = findFrom wordwop dict in
    case fromDict of
        Nothing -> Nothing
        Just (key, s) -> let res = findHyphenationPoint s cols in
                            case res of
                                Nothing -> Nothing
                                Just (a,b) -> Just (a++"-", b++puncs)

fitHyphenatedLine :: [(String, [] String)] -> Int -> [] String -> ([] String, [] String) -- Suggested
fitHyphenatedLine = \dict -> \cols -> \list ->
    let r = fitLine cols list in
        case r of
            (p1, []) -> (p1, [])
            (p1, p:ps) -> case hyphenateWord dict (cols - length (unwords p1) - 1) p of
                            Nothing -> (p1, p:ps)
                            Just (a,b) | (length (unwords p1)) + length a <= cols -> (p1++ [a], b:ps)
                            _ -> (p1, p:ps)

    


fitHyphenatedText :: [(String, [] String)] -> Int -> [] String -> [[] String] -- Required
fitHyphenatedText = \dict -> \cols -> \list -> 
    case list of
        [] -> []
        x:xs -> let (p1, p2) = fitHyphenatedLine dict cols list
                in let res = fitHyphenatedText dict cols p2 in
                [p1] ++ res

-- IMPORTANT: Type here a detailed description of your part 2 solution
-- first I use the fitLine function to get a line without hyphens
-- Then I take the first word of the remaining part fromt the result of fitLine and pass it to the hyphenateWord func
-- this function call the findHyphenationPoint to get the words breaked into two parts. Then the hyphenateWord function
-- uses this result to concatinate the breaked word with the first line and the other part of the word is left for the
-- second line. This whole procedure is part of the function called fitHyphenatedLine, and I use this function in    
-- fitHyphenatedText which calls it recursively for all the lines

hyphenationsPart2 :: [(String, [] String)]
hyphenationsPart2 = [("controls", ["cont", "ro", "ls"]), ("past", ["pa", "st"])]


--main = print(span isAlpha "hello.")

--main = print(fitLine 31 ["st."])

-- --main = print (let (a,b) = fitHyphenatedLine hyphenationsPart2 31 (words text) in
--                 let (a1,b1) = fitHyphenatedLine hyphenationsPart2 31 (b) in
--                     fitHyphenatedLine hyphenationsPart2 31 (b1)
--     )

--main = putStr (unlines (map unwords (fitHyphenatedText hyphenationsPart2 31 (words text))))
--main = putStr (unlines (map unwords (fitText 30 (words text))))
-- Expected Output:

-- He who controls the past cont-
-- rols the future. He who contro-
-- ls the present controls the pa-
-- st.


-- Part 3: Justified Text (5 points)

-- We now want extra spaces to be inserted such that the text is fully justified, except the last line.  We also want the spaces to be spread out so it looks good.  We will use a formula (2^n-1) where n is the number of consecutive extra spaces inserted to calculate the line 'badness' and then choose the line that is least bad.  A line with three extra spaces at different places will have 3 badness whereas if two of the extra spaces are consecutive it will have 4 badness and 7 badness if all three are consecutive.  Note that your code must be based on calculating and using line badness even if you deviate from the hints below.

-- Rest of the description below contains HINTS and you may choose not to follow it.
-- The justifyText function can use the output of fitHyphenatedText and then apply the insertSpaces function on all except the last line.  You may use 'init' which returns all except last element of an array and 'last' which returns the last element, or you may write your own code.  We can use "" (empty strings) to represent extra spaces.  When combined with 'unwords' these will be joined with real spaces.
-- The insertSpaces function should find all possible ways to insert spaces using getSpacingVariations.  It should then calculate the badness of each line using lineBadness and finally find the one with the minimum badness.  If you put badness and the spaced line in a tuple, the standard minimum function will find the minimum correctly.  You may hard-code badness to a constant and getSpacingVariations to always returned the unchanged line (as a one element array) to test till this point.
-- The lineBadness function takes a list of words and a sequence parameter that tells how many extra spaces were there 'before' the start of this part of line.  If the first word is not a blank (i.e., "") you need to add the cost of the sequence of spaces till this point before passing 0 to the recursive call to start a new sequence.
-- Next is getSpacingVariations, which is a recursive function that gives one less space to be inserted to the recursive call and uses getSingleSpaceVariations to insert that one space in the results on the recursive call.  Remember that you have to insert that one space in each of the recursive call results, and even adding a single space has many variants so you need to carefully 'map' and 'concat', or write your own code, or you can use the bind operator here as well.  You may hard-code getSingleSpaceVariations to always insert a space after the first word to test this part.
-- Finally, getSingleSpaceVariations is a recursive function that attempts to insert a space at all possible points except at the very start.

getSingleSpaceVariationsHelper :: [] String -> [] String -> [] ([] String)
getSingleSpaceVariationsHelper = \hist -> \list ->
    case list of
        [] -> []
        x:xs -> [hist++x:"":xs] ++ getSingleSpaceVariationsHelper (hist++[x]) xs

getSingleSpaceVariations :: [] String -> [] ([] String) -- Suggested
getSingleSpaceVariations =  \list -> getSingleSpaceVariationsHelper [] list
    

helper :: [] ([] String) ->  

getSpacingVariations :: Int -> [] String -> [] ([] String) -- Suggested
getSpacingVariations = \num -> \list ->
    case num of
        0 -> []
        _ -> let x:xs = getSingleSpaceVariations list in
                getSpacingVariations (num-1) x


lineBadness :: [] String -> Int -> Int -- Suggested -- comp
lineBadness = \list -> \seq ->
    case list of
        [] -> (2^seq) - 1
        x:xs | x == "" -> lineBadness xs (seq+1)
        x:xs -> (2^seq) - 1 + lineBadness xs 0


getBadness :: [] ([String]) -> [(Int, [String])] -- comp
getBadness = \list ->
    case list of
        [] -> []
        x:xs -> (lineBadness x 0, x):getBadness xs

insertSpaces :: Int -> [] String -> [] String -- Suggested -- comp
insertSpaces = \cols -> \list ->
    let combs = getSpacingVariations (cols - length (unwords list))  list in
        let badness = getBadness combs in
            case minimum badness of
                (a,b) -> b


justifyTextHelper :: [(String, [] String)] -> Int -> [] ([String]) -> [] ([] String)
justifyTextHelper =  \dict -> \cols -> \list ->
    case list of
        [] -> []
        x:xs -> insertSpaces 15 x:justifyTextHelper dict cols xs


justifyText :: [(String, [] String)] -> Int -> [] String -> [] ([] String) -- Required
justifyText = \dict -> \cols -> \list ->
    let lines = fitHyphenatedText dict cols list in justifyTextHelper dict cols (init lines)
        


-- IMPORTANT: Type here a detailed description of your part 3 solution
-- 
-- 
-- 
-- 

hyphenationsPart3 :: [(String, [] String)]
hyphenationsPart3 = [("controls", ["co", "nt", "ro", "ls"]), ("future", ["fu", "tu", "re"]), ("present", ["pre", "se", "nt"])]

line :: [String]
line = ["Hello", "my","name","is"]
main = print( (getSpacingVariations 2 line))

--main = print(map getSingleSpaceVariations line)

--main = putStr (unlines (map unwords (justifyText hyphenationsPart3 15 (words text))))

-- Expected output is given on Line 38 above


-- He who controls
-- the  past cont‐ 
-- rols  the futu‐ 
-- re.  He who co‐ 
-- ntrols the pre‐ 
-- sent   controls 
-- the past.
