module Bot.Commands.Morse where

code =[("a", ".-")
  ,("b", "-...")
  ,("c", "-.-.")
  ,("d", "-..")
  ,("e", ".")
  ,("f", "..-.")
  ,("g", "--.")
  ,("h", "....")
  ,("i", "..")
  ,("j", ".---")
  ,("k", "-.-")
  ,("l", ".-..")
  ,("m", "--")
  ,("n", "-.")
  ,("o", "---")
  ,("p", ".--.")
  ,("q", "--.-")
  ,("r", ".-.")
  ,("s", "...")
  ,("t", "-")
  ,("u", "..-")
  ,("v", "...-")
  ,("w", ".--")
  ,("x", "-..-")
  ,("y", "-.--")
  ,("z", "--..")
  ,("=", "-...-")
  ,("?", "..--..")
  ,("/", "-..-.")
  ,(",", "--..--")
  ,(".", ".-.-.-")
  ,(":", "---...")
  ,("\"", ".----.")
  ,("-", "-....-")
  ,("(", "-.--.-")
  ,(")", "-.--.-")
  ,("0", "-----")
  ,("1", ".----")
  ,("2", "..---")
  ,("3", "...--")
  ,("4", "....-")
  ,("5", ".....")
  ,("6", "-....")
  ,("7", "--...")
  ,("8", "---..")
  ,("9", "----.")]
  
replace (f,s) c = str $ find code
    where
        str [] = c
        str xs = xs
        find (x:xs)
            | f x == c = s x
            | otherwise  = find xs

toMorse = unwords . map (replace (fst, snd) . (:[]))

fromMorse = (replace (snd, fst) =<<) . words
