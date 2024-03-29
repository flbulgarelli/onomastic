module Data.PersonalName.Class (
  ambiguousCenter,
  confidence,
  isFamilish,
  isGivenish,
  merge,
  Class (..)) where


data Class = Given | Family | Other | Bad deriving (Eq, Show)

isGivenish, isFamilish :: Class -> Bool

isGivenish Given = True
isGivenish Other = True
isGivenish _     = False

isFamilish Family = True
isFamilish Other = True
isFamilish _     = False

merge :: [Class] -> Class
merge [x]    = x
merge (Given:xs)  | all isGivenish xs = Given
merge (Family:xs) | all isFamilish xs = Family
merge (Other:xs)  = merge xs
merge _           = Bad

confidence :: (Class, Class) -> Int
confidence (Given, Family)  = 8
confidence (Family, Given)  = 8
confidence (Family, Other)  = 7
confidence (Other, Family)  = 7
confidence (Given, Other)   = 6
confidence (Other, Given)   = 6
confidence (Other, Other)   = 5
confidence (Family, Family) = 4
confidence (Given, Given)   = 4
confidence (Bad, Family)    = 3
confidence (Family, Bad)    = 3
confidence (Bad, Given)     = 2
confidence (Given, Bad)     = 2
confidence (Bad, Other)     = 1
confidence (Other, Bad)     = 1
confidence (Bad, Bad)       = 0


ambiguousCenter :: [Class] -> Bool
ambiguousCenter (Other:xs)  = ambiguousCenter xs
ambiguousCenter (Given:xs)  = ambiguousGivenCenter [] xs
ambiguousCenter (Family:xs) = ambiguousFamilyCenter [] xs
ambiguousCenter _           = False

ambiguousGivenCenter :: [Class] -> [Class] -> Bool
ambiguousGivenCenter os (Given:xs)  = ambiguousGivenCenter [] xs
ambiguousGivenCenter os (Family:xs) = not . null $ os
ambiguousGivenCenter os (Other:xs)  = ambiguousGivenCenter (Other:os) xs
ambiguousGivenCenter os _           = False

ambiguousFamilyCenter :: [Class] -> [Class] -> Bool
ambiguousFamilyCenter os (Family:xs) = ambiguousFamilyCenter [] xs
ambiguousFamilyCenter os (Given:xs)  = not . null $ os
ambiguousFamilyCenter os (Other:xs)  = ambiguousFamilyCenter (Other:os) xs
ambiguousFamilyCenter os _           = False
