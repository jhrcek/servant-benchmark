module Endpoint where

import Control.Applicative ((<|>))
import Data.Aeson (Value)
import qualified Data.Text as T
import Network.HTTP.Types (Method)

{- | An API endpoint.
-
-}
data Endpoint = MkEndpoint
    { -- All endpoint request paths
      path :: [T.Text]
    , -- The endpoint request method
      method :: Maybe Method
    , -- | The request value, where applicable.
      -- Only the first encountered request value is taken into consideration
      -- eg. "user" :> ReqBody '[JSON] Text :> ReqBody '[JSON] Int :> Get '[JSON] User
      -- will produce only a `Text` based request value
      requestValue :: Maybe Value
    }
    deriving (Show, Eq)

instance Semigroup Endpoint where
    a <> b =
        MkEndpoint
            (path a <> path b)
            (method a <> method b)
            -- left biased alternative for request value
            (requestValue a <|> requestValue b)

instance Monoid Endpoint where
    mempty = MkEndpoint mempty mempty Nothing
