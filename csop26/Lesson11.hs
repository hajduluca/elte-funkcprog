module Lesson11 where

data Privilege = Unprivileged | Admin
  deriving (Show, Eq, Enum)

type Username = String
type Password = String
type Database = [(Username, Password, Privilege)]

data Cookie = LoggedOut | LoggedIn Username Privilege
  deriving (Show, Eq)

db :: Database
db = [("dumbledore","abracadabra",Unprivileged), ("root", "secret", Admin), ("bela", "korte", Unprivileged)]

register :: Username -> Password -> Cookie -> Database -> Database
register un pw (LoggedIn _ Admin) db = (un, pw, Unprivileged) : db
register _ _ _ db = db 

getUser :: Username -> Database -> Maybe (Password, Privilege)
getUser _ [] = Nothing
getUser un ((un2, pw, role):xs)
  | un == un2 = Just (pw, role)
  | otherwise = getUser un xs

login :: Username -> Password -> Database -> Cookie
login _ _ [] = LoggedOut
login un pw ((un2, pw2, role):xs)
  | un == un2 && pw == pw2 = (LoggedIn un2 role)
  | otherwise = login un pw xs
  
passwd :: Password -> Cookie -> Database -> Database
passwd _ _ [] = []
passwd _ LoggedOut db = db
passwd newpw c@(LoggedIn un _) (x@(un2, pw, role):xs)
  | un == un2 = (un2, newpw, role) : xs
  | otherwise = x : passwd newpw c xs

delete :: Username -> Cookie -> Database -> Database -- filter lambda/seged fg
delete un (LoggedIn _ Admin) db = filter (\(username, _, _) -> un /= username) db 

users :: Database -> [Username] -- map lambda/seged fg
users db = map (\(username, _, _) -> username) db 