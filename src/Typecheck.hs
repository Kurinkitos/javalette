module Typecheck (
        typecheck
    ) where

import Javalette.Abs

typecheck :: Prog -> Either String Prog
typecheck p = Right p