{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE RecordWildCards #-}

module Kitten.Token where

import Data.Text (Text)
import Numeric

import qualified Data.Text as T

import Kitten.Intrinsic
import Kitten.Location
import Kitten.Util.Text (ToText(..))

data BlockTypeHint
  = NormalBlockHint
  | LayoutBlockHint

data BaseHint
  = BinaryHint
  | OctalHint
  | DecimalHint
  | HexadecimalHint

data Token
  = TkArrow
  | TkBlockBegin !BlockTypeHint
  | TkBlockEnd
  | TkBool Bool
  | TkCase
  | TkChar Char
  | TkComma
  | TkData
  | TkDefault
  | TkDefine
  | TkEllipsis
  | TkFloat !Double
  | TkGroupBegin
  | TkGroupEnd
  | TkIgnore
  | TkIntrinsic !Intrinsic
  | TkImport
  | TkInfix
  | TkInfixLeft
  | TkInfixRight
  | TkInt !Int !BaseHint
  | TkLayout
  | TkMatch
  | TkOperator !Text
  | TkReference
  | TkSemicolon
  | TkText !Text
  | TkVectorBegin
  | TkVectorEnd
  | TkWord !Text

instance Eq Token where
  TkArrow        == TkArrow        = True
  -- TkBlockBegins are equal regardless of BlockTypeHint.
  TkBlockBegin{} == TkBlockBegin{} = True
  TkBlockEnd     == TkBlockEnd     = True
  TkBool a       == TkBool b       = a == b
  TkCase         == TkCase         = True
  TkChar a       == TkChar b       = a == b
  TkComma        == TkComma        = True
  TkData         == TkData         = True
  TkDefault      == TkDefault      = True
  TkDefine       == TkDefine       = True
  TkEllipsis     == TkEllipsis     = True
  TkFloat a      == TkFloat b      = a == b
  TkGroupBegin   == TkGroupBegin   = True
  TkGroupEnd     == TkGroupEnd     = True
  TkIgnore       == TkIgnore       = True
  TkInfix        == TkInfix        = True
  TkInfixLeft    == TkInfixLeft    = True
  TkInfixRight   == TkInfixRight   = True
  TkIntrinsic a  == TkIntrinsic b  = a == b
  TkImport       == TkImport       = True
  -- TkInts are equal regardless of BaseHint.
  TkInt a _      == TkInt b _      = a == b
  TkLayout       == TkLayout       = True
  TkMatch        == TkMatch        = True
  TkOperator a   == TkOperator b   = a == b
  TkReference    == TkReference    = True
  TkSemicolon    == TkSemicolon    = True
  TkText a       == TkText b       = a == b
  TkVectorBegin  == TkVectorBegin  = True
  TkVectorEnd    == TkVectorEnd    = True
  TkWord a       == TkWord b       = a == b
  _              == _              = False

instance Show Token where
  show = \case
    TkArrow -> "->"
    TkBlockBegin NormalBlockHint -> "{"
    TkBlockBegin LayoutBlockHint -> ":"
    TkBlockEnd -> "}"
    TkBool value -> if value then "true" else "false"
    TkCase -> "case"
    TkChar value -> show value
    TkComma -> ","
    TkData -> "data"
    TkDefault -> "default"
    TkDefine -> "define"
    TkEllipsis -> "..."
    TkFloat value -> show value
    TkGroupBegin -> "("
    TkGroupEnd -> ")"
    TkIgnore -> "_"
    TkInfix -> "infix"
    TkInfixLeft -> "infix_left"
    TkInfixRight -> "infix_right"
    TkIntrinsic name -> T.unpack (toText name)
    TkImport -> "import"
    TkInt value hint -> if value < 0 then '-' : shown else shown
      where
      shown = prefix ++ showIntAtBase base (digits !!) (abs value) ""
      (base, prefix, digits) = case hint of
        BinaryHint -> (2, "0b", "01")
        OctalHint -> (8, "0o", ['0'..'7'])
        DecimalHint -> (10, "", ['0'..'9'])
        HexadecimalHint -> (16, "0x", ['0'..'9'] ++ ['A'..'F'])
    TkLayout -> ":"
    TkMatch -> "match"
    TkOperator word -> T.unpack word
    TkReference -> "\\"
    TkSemicolon -> ";"
    TkText value -> show value
    TkVectorBegin -> "["
    TkVectorEnd -> "]"
    TkWord word -> T.unpack word

data Located = Located
  { locatedToken :: Token
  , locatedLocation :: Location
  }

instance Show Located where
  show Located{..} = show locatedToken
